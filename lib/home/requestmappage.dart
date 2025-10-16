import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sal7ly/home/serviceselectionpage.dart';
import 'package:sal7ly/home/technician_tracking_page.dart';
import 'package:sal7ly/setting/technician_types.dart';

class RequestMapPage extends StatefulWidget {
  final String serviceKey;
  final String serviceName;

  const RequestMapPage({
    super.key,
    required this.serviceKey,
    required this.serviceName,
  });

  @override
  State<RequestMapPage> createState() => _RequestMapPageState();
}

class _RequestMapPageState extends State<RequestMapPage> {
  Timer? _timer;
  int _remainingSeconds = 60;
  GoogleMapController? _mapController;
  String? _requestId;
  StreamSubscription<DocumentSnapshot>? _requestSubscription;
  LatLng? _latLng;

  String get localizedServiceName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return TechnicianTypes.getLocalizedTitle(widget.serviceKey, lang);
  }

  @override
  void initState() {
    super.initState();
    _fetchLocationAndStartRequest();
  }

  Future<void> _fetchLocationAndStartRequest() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        Get.snackbar("Error".tr, "Location is disabled".tr);
        Get.offAll(() => ServiceSelectionPage());
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          Get.snackbar("Error".tr, "Location permission denied".tr);
          Get.offAll(() => ServiceSelectionPage());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        Get.snackbar("Error".tr, "Location permission permanently denied".tr);
        Get.offAll(() => ServiceSelectionPage());
        return;
      }

      Position pos = await Geolocator.getCurrentPosition();
      _latLng = LatLng(pos.latitude, pos.longitude);

      _startRequestProcess();
    } catch (e) {
      if (!mounted) return;
      Get.snackbar("Error".tr, "Failed to get location".tr);
      Get.offAll(() => ServiceSelectionPage());
    }
  }

  void _startRequestProcess() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data();
      if (userData == null || userData['name'] == null) {
        if (!mounted) return;
        Get.snackbar("Error".tr, "Incomplete user data".tr);
        Get.offAll(() => ServiceSelectionPage());
        return;
      }

      final requestDoc = await FirebaseFirestore.instance
          .collection('requests')
          .add({
            'userId': user.uid,
            'userName': userData['name'],
            'userPhone': userData['phone'],
            'userAddress': userData['address'],
            'location': {'lat': _latLng!.latitude, 'lng': _latLng!.longitude},
            'service': widget.serviceKey,
            'status': 'searching',
            'createdAt': FieldValue.serverTimestamp(),
          });

      _requestId = requestDoc.id;

      _listenToRequest(_requestId!);
      _startCountdown();
    } catch (e) {
      if (!mounted) return;
      Get.snackbar("Error".tr, "Failed to send request".tr);
      Get.offAll(() => ServiceSelectionPage());
    }
  }

  void _listenToRequest(String requestId) {
    final doc = FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId);

    _requestSubscription = doc.snapshots().listen((snapshot) {
      if (!mounted) return;
      final data = snapshot.data();
      if (data != null && data['status'] == 'assigned') {
        _timer?.cancel();
        _requestSubscription?.cancel();

        final technician = Map<String, dynamic>.from(data['technician'] ?? {});
        technician.putIfAbsent('name', () => "Unknown Name".tr);
        technician.putIfAbsent('phone', () => "Not Available".tr);
        technician.putIfAbsent('imageUrl', () => '');

        if (!mounted) return;
        Get.off(
          () => TechnicianTrackingPage(
            userLocation: _latLng!,
            technicianId: technician['id'],
            requestId: _requestId!,
            serviceKey: widget.serviceKey,
            serviceName: widget.serviceName,
          ),
        );
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _cancelRequest(auto: true);
      } else {
        if (!mounted) return;
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _cancelRequest({bool auto = false}) async {
    _timer?.cancel();
    _requestSubscription?.cancel();

    if (_requestId != null) {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(_requestId)
          .update({
            'status': 'cancelled',
            'cancelReason': auto ? 'timeout' : 'user_cancelled',
          });
    }

    if (!mounted) return;

    if (auto) {
      Get.snackbar("Request Timeout".tr, "No technician found.".tr);
    }

    Get.offAll(() => ServiceSelectionPage());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _requestSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${"Searching for".tr} $localizedServiceName'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _latLng ?? const LatLng(30.0, 31.0),
              zoom: 14,
            ),
            onMapCreated: (c) => _mapController = c,
            myLocationEnabled: true,
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  '$_remainingSeconds ${"seconds remaining".tr}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _cancelRequest(auto: false),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Cancel Request".tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
