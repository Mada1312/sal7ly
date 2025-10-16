import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sal7ly/accountsettings/acc_setting_page.dart';
import 'package:sal7ly/accountsettings/cards.dart';
import 'package:sal7ly/accountsettings/completeuser.dart';
import 'package:sal7ly/accountsettings/delete-acc.dart';
import 'package:sal7ly/accountsettings/edit_acc.dart';
import 'package:sal7ly/accountsettings/email.dart';
import 'package:sal7ly/accountsettings/notifactions.dart';
import 'package:sal7ly/accountsettings/personal_information.dart';
import 'package:sal7ly/accountsettings/saved_adresses.dart';
import 'package:sal7ly/home/serviceselectionpage.dart';
import 'package:sal7ly/pages/firebase_options.dart';
import 'package:sal7ly/pages/auth.dart';
import 'package:sal7ly/pages/loginpage.dart';
import 'package:sal7ly/pages/signup.dart';
import 'package:sal7ly/setting/mytranslations.dart';
import 'package:sal7ly/services/app_config_service.dart';
import 'package:sal7ly/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ أنشئ الخدمة وسجلها في GetX
  final config = Get.put(AppConfigService());

  // ✅ حمل إعدادات التطبيق
  await config.loadConfig(appKey: 'sal7ly');

  config.commissionRate.listen((value) {
    print('💰 Commission updated: $value%');
  });

  print('✅ App Name: ${config.appName.value}');
  print('✅ Commission Rate: ${config.commissionRate.value}%');
  print(
    '✅ Push Notifications: ${config.enablePush.value ? 'Enabled' : 'Disabled'}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Auth(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/LogPage', page: () => const Loginpage()),
        GetPage(name: '/SignPage', page: () => const SignUpScreen()),
        GetPage(name: '/services', page: () => ServiceSelectionPage()),
        GetPage(
          name: '/complete-info',
          page: () => const CompleteUserInfoPage(),
        ),
        GetPage(name: '/update-account', page: () => const EditAccountPage()),
        GetPage(
          name: '/account-settings',
          page: () => const AccountSettingsPage(),
        ),
        GetPage(
          name: '/edit-personal-info',
          page: () => const PersonalInfoPage(),
        ),
        GetPage(
          name: '/account-addresses',
          page: () => const SavedAddressPage(),
        ),
        GetPage(name: '/account-email', page: () => const EmailPage()),
        GetPage(name: '/account-cards', page: () => const SavedCardsPage()),
        GetPage(
          name: '/account-notifications',
          page: () => const NotificationsPage(),
        ),
        GetPage(name: '/account-delete', page: () => const DeleteAccountPage()),
      ],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      translations: MyTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
