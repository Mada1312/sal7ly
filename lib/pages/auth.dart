import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Future.microtask(() {
      if (user == null) {
        if (Get.currentRoute == '/' || Get.currentRoute == '/auth') {
          Get.offAllNamed('/LogPage');
        }
      } else {
        if (Get.currentRoute == '/' || Get.currentRoute == '/auth') {
          Get.offAllNamed('/services');
        }
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
