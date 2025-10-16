import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedAddressPage extends StatefulWidget {
  const SavedAddressPage({super.key});

  @override
  State<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends State<SavedAddressPage> {
  final governorateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final streetController = TextEditingController();
  final buildingNumberController = TextEditingController();
  final floorNumberController = TextEditingController();
  final apartmentNumberController = TextEditingController();

  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  Future<void> fetchAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data();
    final address = data?['address'] as Map<String, dynamic>? ?? {};

    governorateController.text = address['governorate'] ?? '';
    cityController.text = address['city'] ?? '';
    areaController.text = address['area'] ?? '';
    streetController.text = address['street'] ?? '';
    buildingNumberController.text = address['building'] ?? '';
    floorNumberController.text = address['floor'] ?? '';
    apartmentNumberController.text = address['apartment'] ?? '';
  }

  Future<void> saveAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'address': {
        'governorate': governorateController.text.trim(),
        'city': cityController.text.trim(),
        'area': areaController.text.trim(),
        'street': streetController.text.trim(),
        'building': buildingNumberController.text.trim(),
        'floor': floorNumberController.text.trim(),
        'apartment': apartmentNumberController.text.trim(),
      },
    });

    Get.snackbar(
      'Success'.tr,
      'Address updated successfully.'.tr,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    Get.offNamed('/account-settings');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Address".tr),
        backgroundColor: isDark ? Colors.blue.shade800 : Colors.blue.shade300,
        centerTitle: true,
      ),
      body: Obx(() {
        return isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  buildTextField("Governorate".tr, governorateController),
                  buildTextField("City".tr, cityController),
                  buildTextField("Area".tr, areaController),
                  buildTextField("Street".tr, streetController),
                  buildTextField(
                    "Building Number".tr,
                    buildingNumberController,
                  ),
                  buildTextField("Floor Number".tr, floorNumberController),
                  buildTextField(
                    "Apartment Number".tr,
                    apartmentNumberController,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Save Address".tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
  void dispose() {
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
