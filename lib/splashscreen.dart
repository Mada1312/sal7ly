import 'package:flutter/material.dart';
import 'package:sal7ly/pages/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // استنى 5 ثواني وبعدين انتقل للصفحة الرئيسية
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Auth(),
        ), // استبدل HomePage باسم صفحتك الرئيسية
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 214, 204, 188),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
            ), // استبدل 'assets/logo.png' بمسار صورتك

            Text('Welcome to Sal7ly'),
            Text('We hope you have a great experience'),
          ],
        ),
      ),
    );
  }
}
