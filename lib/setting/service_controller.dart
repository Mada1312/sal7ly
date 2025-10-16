import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  // الخدمة المختارة
  var selectedService = Rxn<Map<String, dynamic>>();

  // قائمة الخدمات
  final services = [
    {
      "key": "electrician",
      "title": "Electrician".tr,
      "icon": FontAwesomeIcons.bolt,
      "color": Colors.orange,
    },
    {
      "key": "plumber",
      "title": "Plumber".tr,
      "icon": FontAwesomeIcons.wrench,
      "color": Colors.blue,
    },
    {
      "key": "painter",
      "title": "Painter".tr,
      "icon": FontAwesomeIcons.paintRoller,
      "color": Colors.green,
    },
    {
      "key": "ac",
      "title": "AC Technician".tr,
      "icon": FontAwesomeIcons.snowflake,
      "color": Colors.lightBlue,
    },
    {
      "key": "carpenter",
      "title": "Carpenter".tr,
      "icon": FontAwesomeIcons.hammer,
      "color": Colors.brown,
    },
  ];

  // اختيار خدمة
  void selectService(Map<String, dynamic> service) {
    selectedService.value = service;
  }
}
