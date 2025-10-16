import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sal7ly/setting/controller.dart';

class UserInfoFormPage extends StatelessWidget {
  final controller = Get.put(UserInfoController());

  UserInfoFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Info')),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.governorateController,
                      decoration: const InputDecoration(
                        labelText: 'Governorate',
                      ),
                    ),
                    TextField(
                      controller: controller.cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    TextField(
                      controller: controller.areaController,
                      decoration: const InputDecoration(labelText: 'Area'),
                    ),
                    TextField(
                      controller: controller.streetController,
                      decoration: const InputDecoration(
                        labelText: 'Street Name',
                      ),
                    ),
                    TextField(
                      controller: controller.buildingNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Building No.',
                      ),
                    ),
                    TextField(
                      controller: controller.floorNumberController,
                      decoration: const InputDecoration(labelText: 'Floor No.'),
                    ),
                    TextField(
                      controller: controller.apartmentNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Apartment No.',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => controller.getCurrentLocation(),
                      icon: const Icon(Icons.my_location),
                      label: const Text("Use Current Location"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.saveData(),
                      child: const Text("Save and Continue"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
