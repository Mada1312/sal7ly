import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sal7ly/accountsettings/acc_setting_page.dart';
import 'package:sal7ly/home/support_page.dart';
import 'package:sal7ly/pages/loginpage.dart';
import 'package:sal7ly/setting/service_controller.dart' show ServiceController;
import 'package:sal7ly/setting/settings.dart';
import 'package:sal7ly/home/requestmappage.dart';

class ServiceSelectionPage extends StatelessWidget {
  ServiceSelectionPage({super.key});

  final ServiceController controller = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale?.languageCode ?? 'ar';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sal7ly'.tr),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.blue.shade800
            : Colors.blue.shade300,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blue.shade800
                    : Colors.blue.shade300,
              ),
              child: Center(
                child: Text(
                  'Menu'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Account Settings'.tr),
              onTap: () => Get.to(() => const AccountSettingsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent, color: Colors.green),
              title: Text("Help".tr),
              onTap: () {
                Get.to(() => const SupportPage()); // ✅ تفعيل الصفحة
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Settings'.tr),
              onTap: () => Get.to(() => const SettingsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Log Out'.tr,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(() => const Loginpage());
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                      children: controller.services.map((service) {
                        final isSelected =
                            controller.selectedService.value == service;

                        return GestureDetector(
                          onTap: () => controller.selectService(service),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (service["color"] as Color?)?.withOpacity(
                                          1.0,
                                        ) ??
                                        Colors.blue
                                  : (service["color"] as Color?)?.withOpacity(
                                          0.8,
                                        ) ??
                                        Colors.blueGrey,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  service["icon"] as IconData,
                                  color: Colors.white,
                                  size: 40,
                                ),

                                const SizedBox(height: 10),
                                Text(
                                  service["title"]
                                      .toString()
                                      .tr, // ترجم الخدمات
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Obx(
                () => controller.selectedService.value != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final selected = controller.selectedService.value!;
                            Get.to(
                              () => RequestMapPage(
                                serviceKey: selected["key"],
                                serviceName: selected["title"],
                              ),
                            );
                          },
                          child: Text("Request Technician".tr),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
