import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sal7ly/home/serviceselectionpage.dart';

class TechnicianSummaryPage extends StatefulWidget {
  final String requestId;

  const TechnicianSummaryPage({super.key, required this.requestId});

  @override
  State<TechnicianSummaryPage> createState() => _TechnicianSummaryPageState();
}

class _TechnicianSummaryPageState extends State<TechnicianSummaryPage> {
  double total = 0;
  double rating = 3;
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    final requestRef = FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId);

    return Scaffold(
      appBar: AppBar(title: Text('Work Summary'.tr)),
      body: StreamBuilder<DocumentSnapshot>(
        stream: requestRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final issues = data['issues'] as List<dynamic>? ?? [];

          // جلب الأسعار من Firestore
          final basePrice = (data['basePrice'] ?? 0).toDouble();
          final addedPrice = (data['addedPrice'] ?? 0).toDouble();
          const serviceFee = 20.0;
          total = basePrice + addedPrice + serviceFee;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Issues Fixed'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        issues.length + 3, // أعطال + Base + Extra + Service Fee
                    itemBuilder: (context, index) {
                      if (index < issues.length) {
                        final issue = issues[index];
                        return ListTile(
                          title: Text(issue['title'] ?? 'Issue'),
                          trailing: Text("${issue['price'] ?? 0} EGP"),
                        );
                      } else if (index == issues.length) {
                        return ListTile(
                          title: const Text("Base Price"),
                          trailing: Text("$basePrice EGP"),
                        );
                      } else if (index == issues.length + 1) {
                        return ListTile(
                          title: const Text("Extra from Technician"),
                          trailing: Text("$addedPrice EGP"),
                        );
                      } else {
                        return const ListTile(
                          title: Text("Service Fee"),
                          trailing: Text("20 EGP"),
                        );
                      }
                    },
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$total EGP",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Please rate the technician'.tr),
                const SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (value) {
                    rating = value;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: submitting
                        ? null
                        : () async {
                            setState(() => submitting = true);

                            final latestSnapshot = await requestRef.get();
                            final requestData =
                                latestSnapshot.data() as Map<String, dynamic>;

                            final technicianId =
                                requestData['technician']?['id'];

                            if (technicianId == null ||
                                technicianId.toString().isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Technician ID not found!',
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.black,
                              );
                              setState(() => submitting = false);
                              return;
                            }

                            await requestRef.update({'customerRating': rating});

                            final techRef = FirebaseFirestore.instance
                                .collection('technicians')
                                .doc(technicianId);

                            final techSnap = await techRef.get();
                            final oldRating = (techSnap.data()?['rating'] ?? 0)
                                .toDouble();
                            final totalRatings =
                                (techSnap.data()?['ratingCount'] ?? 0).toInt();

                            final newAverage =
                                ((oldRating * totalRatings) + rating) /
                                (totalRatings + 1);

                            await techRef.update({
                              'rating': newAverage,
                              'ratingCount': totalRatings + 1,
                            });

                            Get.snackbar(
                              'Thank you',
                              'Your rating has been submitted successfully',
                              backgroundColor: Colors.green.shade100,
                              colorText: Colors.black,
                            );

                            Get.offAll(() => ServiceSelectionPage());
                          },
                    child: submitting
                        ? const CircularProgressIndicator()
                        : Text('Done'.tr),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
