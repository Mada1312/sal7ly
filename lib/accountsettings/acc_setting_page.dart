import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings".tr),
        centerTitle: true,
        backgroundColor: isDark ? Colors.blue.shade800 : Colors.blue.shade300,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSettingsTile(
            icon: Icons.person,
            title: "Personal Information".tr,
            onTap: () => Get.toNamed('/edit-personal-info'),
          ),
          buildSettingsTile(
            icon: Icons.location_on,
            title: "Saved Address".tr,
            onTap: () => Get.toNamed('/account-addresses'),
          ),
          buildSettingsTile(
            icon: Icons.email,
            title: "Email".tr,
            onTap: () => Get.toNamed('/account-email'),
          ),
          buildSettingsTile(
            icon: Icons.credit_card,
            title: "Saved Cards".tr,
            onTap: () => Get.toNamed('/account-cards'),
          ),
          buildSettingsTile(
            icon: Icons.notifications,
            title: "Notifications".tr,
            onTap: () => Get.toNamed('/account-notifications'),
          ),
          buildSettingsTile(
            icon: Icons.delete,
            title: "Delete Account".tr,
            textColor: Colors.red,
            onTap: () => Get.toNamed('/account-delete'),
          ),
        ],
      ),
    );
  }

  Widget buildSettingsTile({
    required IconData icon,
    required String title,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.blue),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
