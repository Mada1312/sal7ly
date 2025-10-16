import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CompleteUserInfoPage extends StatefulWidget {
  const CompleteUserInfoPage({super.key});

  @override
  State<CompleteUserInfoPage> createState() => _CompleteUserInfoPageState();
}

class _CompleteUserInfoPageState extends State<CompleteUserInfoPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final governorateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final streetController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final apartmentController = TextEditingController();

  LatLng? selectedLocation;
  final isLoading = false.obs;

  Future<void> useCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar('Location Error', 'Permission denied');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);
    });

    Get.snackbar('Location', 'Current location selected');
  }

  Future<void> saveUserData() async {
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
          'building': buildingController.text.trim(),
          'floor': floorController.text.trim(),
          'apartment': apartmentController.text.trim(),
        },
        'location': selectedLocation != null
            ? {
                'lat': selectedLocation!.latitude,
                'lng': selectedLocation!.longitude,
              }
            : null,
      });

      Get.snackbar(
        'Success',
        'Information saved successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed('/services');
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Info')),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Personal Info",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              buildTextField("Full Name", nameController),
              buildTextField("Phone Number", phoneController),
              const SizedBox(height: 16),
              const Text(
                "Address Info",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              buildTextField("Governorate", governorateController),
              buildTextField("City", cityController),
              buildTextField("Area", areaController),
              buildTextField("Street", streetController),
              buildTextField("Building No.", buildingController),
              buildTextField("Floor No.", floorController),
              buildTextField("Apartment No.", apartmentController),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: useCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text("Use Current Location"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save and Continue",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    governorateController.dispose();
    cityController.dispose();
    areaController.dispose();
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    super.dispose();
  }
}
