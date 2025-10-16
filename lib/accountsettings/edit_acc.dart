import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final governorateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final streetController = TextEditingController();
  final buildingNumberController = TextEditingController();
  final floorNumberController = TextEditingController();
  final apartmentNumberController = TextEditingController();

  final isLoading = false.obs;
  final user = FirebaseAuth.instance.currentUser;

  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    if (user == null) return;
    isLoading.value = true;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      final data = doc.data();
      if (data != null) {
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';

        final address = Map<String, dynamic>.from(data['address'] ?? {});
        governorateController.text = address['governorate'] ?? '';
        cityController.text = address['city'] ?? '';
        areaController.text = address['area'] ?? '';
        streetController.text = address['street'] ?? '';
        buildingNumberController.text = address['building'] ?? '';
        floorNumberController.text = address['floor'] ?? '';
        apartmentNumberController.text = address['apartment'] ?? '';

        final loc = data['location'];
        if (loc != null) {
          selectedLocation = LatLng(loc['lat'], loc['lng']);
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      setState(() {});
    }
  }

  Future<void> getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Error',
        'Permission denied',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);
    });

    Get.snackbar(
      'Location',
      'Current location selected',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> saveChanges() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
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
            if (selectedLocation != null)
              'location': {
                'lat': selectedLocation!.latitude,
                'lng': selectedLocation!.longitude,
              },
          });

      Get.snackbar(
        'Success',
        'Account updated successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      Get.offAllNamed('/account-settings');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update data',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
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
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Account Info"),
        backgroundColor: isDark ? Colors.blue.shade800 : Colors.blue.shade300,
        centerTitle: true,
      ),
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
              buildTextField("Name", nameController),
              buildTextField("Phone", phoneController),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                "Address Info",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              buildTextField("Governorate", governorateController),
              buildTextField("City", cityController),
              buildTextField("Area", areaController),
              buildTextField("Street", streetController),
              buildTextField("Building No.", buildingNumberController),
              buildTextField("Floor No.", floorNumberController),
              buildTextField("Apartment No.", apartmentNumberController),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: getCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text("Use Current Location"),
              ),
              const SizedBox(height: 16),
              if (selectedLocation != null)
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: selectedLocation!,
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('current'),
                        position: selectedLocation!,
                      ),
                    },
                    onTap: (latLng) {
                      setState(() {
                        selectedLocation = latLng;
                      });
                      Get.snackbar(
                        'Location Updated',
                        'Location changed manually.',
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
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
    buildingNumberController.dispose();
    floorNumberController.dispose();
    apartmentNumberController.dispose();
    super.dispose();
  }
}
