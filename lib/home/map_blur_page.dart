import 'dart:ui';
import 'package:flutter/material.dart';

class MapBlurPage extends StatelessWidget {
  final String serviceName;

  const MapBlurPage({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Searching for $serviceName'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // خلفية صورة خريطة (وهمية حالياً)
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_mock.jpg', // تأكد من وجود هذه الصورة داخل مجلد assets/images/
              fit: BoxFit.cover,
            ),
          ),

          // تأثير Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
        ],
      ),
    );
  }
}
