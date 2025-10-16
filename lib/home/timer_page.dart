import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartWorkPage extends StatefulWidget {
  final String requestId;
  final double price;

  const StartWorkPage({
    super.key,
    required this.requestId,
    required this.price,
  });

  @override
  State<StartWorkPage> createState() => _StartWorkPageState();
}

class _StartWorkPageState extends State<StartWorkPage> {
  late Timer _timer;
  int secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start Work'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Work in Progress'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              _formatTime(secondsElapsed),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${'Final Price'.tr}: ${widget.price} EGP',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(
                  '/rate',
                  arguments: {
                    'requestId': widget.requestId,
                    'duration': secondsElapsed,
                  },
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: Text('Finish Work'.tr),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
