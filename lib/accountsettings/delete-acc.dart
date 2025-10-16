import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  void _showReauthDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Get.defaultDialog(
      title: "Re-authenticate".tr,
      content: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email".tr),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "Password".tr),
            obscureText: true,
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          _deleteAccount(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
        },
        child: Text("Confirm Delete".tr),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text("Cancel".tr)),
    );
  }

  Future<void> _deleteAccount(String email, String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final cred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);

      // حذف بيانات المستخدم من Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // حذف الحساب من Firebase
      await user.delete();

      Get.snackbar(
        "Deleted".tr,
        "Account deleted successfully".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAllNamed('/LogPage');
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "${'Failed to delete account'.tr}: $e",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account".tr),
        backgroundColor: isDark ? Colors.blue.shade800 : Colors.blue.shade300,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Warning!".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Deleting your account will permanently erase all your data. This action cannot be undone."
                  .tr,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _showReauthDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.delete),
              label: Text("Delete My Account".tr),
            ),
          ],
        ),
      ),
    );
  }
}
