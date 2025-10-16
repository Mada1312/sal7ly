import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final governorateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final streetController = TextEditingController();
  final buildingNumberController = TextEditingController();
  final floorNumberController = TextEditingController();
  final apartmentNumberController = TextEditingController();

  var selectedLocation = Rxn<LatLng>();
  var isLoading = false.obs;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar('Location Error', 'Permission Denied');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      selectedLocation.value = LatLng(position.latitude, position.longitude);
      Get.snackbar('Location', 'Location selected successfully.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': {
          'governorate': governorateController.text.trim(),
          'city': cityController.text.trim(),
          'area': areaController.text.trim(),
          'street': streetController.text.trim(),
          'building': buildingNumberController.text.trim(),
          'floor': floorNumberController.text.trim(),
          'apartment': apartmentNumberController.text.trim(),
        },
        'location': {
          'lat': selectedLocation.value?.latitude,
          'lng': selectedLocation.value?.longitude,
        },
      }, SetOptions(merge: true));

      Get.snackbar('Success', 'All data saved successfully');
      Get.offAllNamed('/services');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    governorateController.dispose();
    cityController.dispose();
    areaController.dispose();
    streetController.dispose();
    buildingNumberController.dispose();
    floorNumberController.dispose();
    apartmentNumberController.dispose();
    super.onClose();
  }
}
