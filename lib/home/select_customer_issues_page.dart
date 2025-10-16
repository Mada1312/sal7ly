import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sal7ly/home/waiting_for_price_page.dart';

class SelectCustomerIssuesPage extends StatefulWidget {
  final String requestId;

  const SelectCustomerIssuesPage({super.key, required this.requestId});

  @override
  State<SelectCustomerIssuesPage> createState() =>
      _SelectCustomerIssuesPageState();
}

class _SelectCustomerIssuesPageState extends State<SelectCustomerIssuesPage> {
  final TextEditingController otherController = TextEditingController();
  final List<String> selectedIssues = [];
  bool showOtherInput = false;

  // الخريطة تدعم العربي والإنجليزي والاختصارات
  final Map<String, String> serviceKeyMap = {
    // كهربائي
    "كهربائي": "Electrician",
    "electrician": "Electrician",
    "كهربا": "Electrician",
    "elec": "Electrician",

    // سباك
    "سباك": "Plumber",
    "plumber": "Plumber",
    "سباكة": "Plumber",
    "plumb": "Plumber",

    // نجار
    "نجار": "Carpenter",
    "carpenter": "Carpenter",
    "نجارة": "Carpenter",
    "carp": "Carpenter",

    // نقاش
    "نقاش": "Painter",
    "painter": "Painter",
    "دهان": "Painter",
    "paint": "Painter",

    // فني تكييف
    "فني تكييف": "AC Technician",
    "ac technician": "AC Technician",
    "تكييف": "AC Technician",
    "ac": "AC Technician",
  };

  String normalizeServiceName(String name) {
    final normalized = name.trim().toLowerCase();

    // لو الكلمة مطابقة مباشرة
    if (serviceKeyMap.containsKey(normalized)) {
      return serviceKeyMap[normalized]!;
    }

    // مطابقة جزئية: لو أي كلمة أو جزء موجود في النص
    for (final key in serviceKeyMap.keys) {
      if (normalized.contains(key.toLowerCase())) {
        return serviceKeyMap[key]!;
      }
    }

    return '';
  }

  Future<Map<String, dynamic>> fetchIssues() async {
    // 1. جلب بيانات الطلب
    final requestDoc = await FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId)
        .get();

    if (!requestDoc.exists) {
      throw Exception("لم يتم العثور على الطلب");
    }

    final serviceName = requestDoc.data()?['service'];

    if (serviceName == null || serviceName.isEmpty) {
      throw Exception("نوع الخدمة غير محدد في الطلب");
    }

    // 2. التطبيع والبحث عن الخدمة
    final serviceKey = normalizeServiceName(serviceName);

    if (serviceKey.isEmpty) {
      throw Exception("نوع الخدمة غير معروف أو غير مدعوم");
    }

    // 3. جلب الأعطال من الـ document الخاص بالخدمة
    final issuesDoc = await FirebaseFirestore.instance
        .collection('issues_by_service')
        .doc(serviceKey)
        .get();

    final issuesData = issuesDoc.data();
    if (issuesData == null || !issuesData.containsKey('issues')) {
      throw Exception("لا توجد أعطال متاحة لهذه الخدمة");
    }

    // 4. تحويل الـ array لقائمة
    final List<Map<String, dynamic>> issuesList =
        List<Map<String, dynamic>>.from(issuesData['issues']);

    return {'serviceKey': serviceKey, 'issuesList': issuesList};
  }

  void submitIssues(List<Map<String, dynamic>> allIssues) async {
    String otherIssue = otherController.text.trim();

    final selectedIssueObjects = allIssues
        .where((issue) {
          final locale = Get.locale?.languageCode ?? 'en';
          final title = locale == 'ar'
              ? (issue['name_ar'] ?? '')
              : (issue['name_en'] ?? '');
          return selectedIssues.contains(title);
        })
        .map((issue) {
          return {
            'id':
                issue['id'] ??
                'unknown_${DateTime.now().millisecondsSinceEpoch}',
            'category': issue['category'] ?? '',
            'description': issue['description'] ?? '',
            'name_ar': issue['name_ar'] ?? '',
            'name_en': issue['name_en'] ?? '',
            'price': issue['price'] ?? 0,
          };
        })
        .toList();

    // إضافة "أخرى"
    bool hasOther = false;
    if (showOtherInput && otherIssue.isNotEmpty) {
      hasOther = true;
      selectedIssueObjects.add({
        'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
        'category': 'Other',
        'description': otherIssue,
        'name_ar': otherIssue,
        'name_en': otherIssue,
        'price': 0,
      });
    }

    if (selectedIssueObjects.isEmpty) {
      Get.snackbar("تحذير", "يرجى اختيار أو إدخال المشكلة");
      return;
    }

    try {
      final requestRef = FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.requestId);

      // ✅ حساب السعر الأساسي (مجموع أسعار الأعطال المختارة)
      final double basePrice = selectedIssueObjects.fold<double>(
        0,
        (sum, issue) => sum + (issue['price'] ?? 0),
      );

      // ✅ تجهيز البيانات للتحديث في Firestore
      final Map<String, dynamic> updateData = {
        'issues': selectedIssueObjects,
        'basePrice': basePrice, // أضفنا هذا السطر
      };

      if (hasOther) {
        updateData['status'] = 'waiting_admin_pricing';
      }

      await requestRef.update(updateData);

      Get.snackbar("تم", "تم حفظ الأعطال بنجاح");

      if (hasOther) {
        Get.to(
          () => WaitingForPricePage(
            requestId: widget.requestId,
            isTechnician: false,
          ),
        );
      } else {
        Get.to(
          () => WaitingForPricePage(
            requestId: widget.requestId,
            isTechnician: false,
          ),
        );
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل في الحفظ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale?.languageCode ?? 'en';

    return Scaffold(
      appBar: AppBar(title: const Text("اختر المشكلة")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchIssues(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("خطأ: ${snapshot.error}"));
            }

            final issuesList =
                snapshot.data!['issuesList'] as List<Map<String, dynamic>>;

            return ListView(
              children: [
                Text(
                  "يرجى اختيار الأعطال التي تواجهها:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...issuesList.map((issue) {
                  final title = locale == 'ar'
                      ? issue['name_ar'] ?? ''
                      : issue['name_en'] ?? '';

                  return CheckboxListTile(
                    value: selectedIssues.contains(title),
                    title: Text(title),
                    subtitle: Text("${issue['price']} EGP"),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          selectedIssues.add(title);
                        } else {
                          selectedIssues.remove(title);
                        }
                      });
                    },
                  );
                }).toList(),
                CheckboxListTile(
                  value: showOtherInput,
                  title: const Text("أخرى"),
                  onChanged: (val) {
                    setState(() => showOtherInput = val ?? false);
                  },
                ),
                if (showOtherInput)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: otherController,
                      decoration: const InputDecoration(
                        labelText: "صف المشكلة",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ),
                ElevatedButton(
                  onPressed: () => submitIssues(issuesList),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("إرسال", style: TextStyle(fontSize: 18)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
