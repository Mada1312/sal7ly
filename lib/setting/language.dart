import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  void changeLanguage(String langCode) {
    final locale = Locale(langCode);
    Get.updateLocale(locale);
    GetStorage().write('langCode', langCode);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final currentLang = Get.locale?.languageCode ?? 'en';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Settings"),
        backgroundColor: isDark ? Colors.blue.shade800 : Colors.blue.shade300,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Language",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            RadioListTile<String>(
              title: const Text("English"),
              value: 'en',
              groupValue: currentLang,
              onChanged: (value) => changeLanguage(value!),
            ),
            RadioListTile<String>(
              title: const Text("العربية"),
              value: 'ar',
              groupValue: currentLang,
              onChanged: (value) => changeLanguage(value!),
            ),
          ],
        ),
      ),
    );
  }
}
