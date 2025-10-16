import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = Get.isDarkMode;
  final box = GetStorage();
  Locale selectedLocale = const Locale('en', 'US'); // default

  @override
  void initState() {
    super.initState();
    final currentLocale = Get.locale;
    if (currentLocale != null) {
      if (currentLocale.languageCode == 'ar') {
        selectedLocale = const Locale('ar', 'EG');
      } else {
        selectedLocale = const Locale('en', 'US');
      }
    }
  }

  void _changeLanguage(Locale? locale) {
    if (locale == null) return;
    setState(() {
      selectedLocale = locale;
    });
    box.write('langCode', locale.languageCode);
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Change Language'.tr),
            trailing: DropdownButton<Locale>(
              value: selectedLocale,
              onChanged: _changeLanguage,
              items: const [
                DropdownMenuItem(
                  value: Locale('en', 'US'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('ar', 'EG'),
                  child: Text('العربية'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            title: Text('Theme Mode'.tr),
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                setState(() {
                  isDark = value;
                  Get.changeThemeMode(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
