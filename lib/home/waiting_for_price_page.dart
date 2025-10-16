import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sal7ly/home/serviceselectionpage.dart';
import 'package:sal7ly/home/summary.dart';

class WaitingForPricePage extends StatefulWidget {
  final String requestId;
  final bool isTechnician;

  const WaitingForPricePage({
    super.key,
    required this.requestId,
    required this.isTechnician,
  });

  @override
  State<WaitingForPricePage> createState() => _WaitingForPricePageState();
}

class _WaitingForPricePageState extends State<WaitingForPricePage> {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool timerStarted = false;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
    timerStarted = true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId);

    return Scaffold(
      appBar: AppBar(title: Text('Waiting for price'.tr)),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No request data available.'.tr));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final price = data['finalPrice'];
          final status = data['status'];
          final paymentConfirmed = data['paymentConfirmed'] ?? false;

          if (status == 'accepted_by_customer') {
            if (!timerStarted) startTimer();

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Work started'.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      formatDuration(_duration),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Working...'.tr, style: const TextStyle(fontSize: 16)),
                    if (widget.isTechnician) ...[
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Collect payment'.tr,
                            middleText:
                                '${'You must collect the amount from the customer:'.tr} ${price.toString()} EGP',
                            confirm: ElevatedButton(
                              onPressed: () async {
                                await docRef.update({
                                  'status': 'cash_paid_and_closed',
                                });
                                Get.back();
                              },
                              child: Text('Collected'.tr),
                            ),
                          );
                        },
                        child: Text('Finish and collect'.tr),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          if (status == 'waiting_customer_approval' && price != null) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${'Price is set:'.tr} ${price.toString()} EGP',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text('Accept'.tr),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      await docRef.update({
                        'priceApproved': true,
                        'status': 'accepted_by_customer',
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: Text('Reject'.tr),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.to(
                        () => ConfirmRejectionPaymentPage(
                          requestId: widget.requestId,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          if (status == 'rejected_by_customer') {
            return Center(
              child: Text(
                paymentConfirmed
                    ? 'Waiting for technician to confirm payment...'.tr
                    : 'Waiting for customer to confirm payment...'.tr,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (status == 'waiting_cash_confirm') {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Customer confirmed the payment.\nPlease confirm receipt.'
                          .tr,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (widget.isTechnician)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.attach_money),
                        label: Text('Confirm cash receipt'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          await docRef.update({
                            'status': 'cash_paid_and_closed',
                          });
                        },
                      )
                    else
                      Text(
                        'Please wait, you will be redirected after technician confirmation.'
                            .tr,
                        style: const TextStyle(fontSize: 18),
                      ),
                  ],
                ),
              ),
            );
          }

          if (status == 'cash_paid_and_closed') {
            Future.microtask(() {
              Get.snackbar(
                'Thank you'.tr,
                'Thank you for using Sal7ly'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade100,
                colorText: Colors.black,
                duration: const Duration(seconds: 2),
              );
              Get.off(TechnicianSummaryPage(requestId: widget.requestId));
            });
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'Please wait while the technician sets the price...'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ConfirmRejectionPaymentPage extends StatelessWidget {
  final String requestId;

  const ConfirmRejectionPaymentPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId);

    return Scaffold(
      appBar: AppBar(title: Text('Confirm payment'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have rejected the price.\nYou must pay the service fee of 50 EGP'
                  .tr,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await docRef.update({
                  'paymentConfirmed': true,
                  'status': 'rejected_by_customer',
                });

                Get.snackbar(
                  'Thank you!',
                  'Thank you for using Sal7ly. Your payment confirmation has been received.',
                  backgroundColor: Colors.green.shade100,
                  colorText: Colors.black,
                );

                Get.offAll(() => ServiceSelectionPage());
              },

              child: Text('Confirm payment'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
