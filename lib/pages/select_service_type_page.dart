import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectServiceTypePage extends StatelessWidget {
  final List<Map<String, String>> services = [
    {'id': 'carpenter', 'name_ar': 'نجار', 'name_en': 'Carpenter'},
    {'id': 'plumber', 'name_ar': 'سباك', 'name_en': 'Plumber'},
    {'id': 'electrician', 'name_ar': 'كهربائي', 'name_en': 'Electrician'},
    {'id': 'painter', 'name_ar': 'نقاش', 'name_en': 'Painter'},
    {'id': 'ac_technician', 'name_ar': 'فني تكييف', 'name_en': 'AC Technician'},
  ];

  String getServiceName(Map<String, String> service) {
    final locale = Get.locale?.languageCode ?? 'ar';
    return locale == 'en' ? service['name_en']! : service['name_ar']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر نوع الخدمة')),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ListTile(
            title: Text(getServiceName(service)),
            leading: const Icon(Icons.build),
            onTap: () {
              final selectedServiceId = service['id']!;
              // ⬇️ روح على شاشة الأعطال وحدد نوع الخدمة
              Get.toNamed(
                '/selectIssues',
                arguments: {'serviceType': selectedServiceId},
              );
            },
          );
        },
      ),
    );
  }
}
