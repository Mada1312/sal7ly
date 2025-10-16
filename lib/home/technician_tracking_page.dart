import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sal7ly/home/select_customer_issues_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicianTrackingPage extends StatefulWidget {
  final String technicianId;
  final LatLng userLocation;
  final String requestId;
  final String serviceKey;
  final String serviceName;

  const TechnicianTrackingPage({
    super.key,
    required this.technicianId,
    required this.userLocation,
    required this.requestId,
    required this.serviceKey,
    required this.serviceName,
  });

  @override
  State<TechnicianTrackingPage> createState() => _TechnicianTrackingPageState();
}

class _TechnicianTrackingPageState extends State<TechnicianTrackingPage> {
  GoogleMapController? _mapController;
  LatLng? _technicianLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  StreamSubscription<DocumentSnapshot>? _techSubscription;
  StreamSubscription<DocumentSnapshot>? _requestSubscription;

  String? technicianImageUrl;
  String technicianName = 'Unknown';
  String technicianPhone = 'Not available';

  String _distanceText = "";
  String _etaText = "";

  final String googleApiKey =
      "AIzaSyAZHlDQBDRtQmEfu0Lrt_JJT8UV5QIYrZc"; // ضع مفتاحك هنا

  @override
  void initState() {
    super.initState();
    _fetchTechnicianData();
    _listenToTechnicianLocation();
    _listenToRequestStatus();
  }

  @override
  void dispose() {
    _techSubscription?.cancel();
    _requestSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchTechnicianData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .doc(widget.technicianId)
        .get();

    final data = snapshot.data();
    if (data != null && mounted) {
      setState(() {
        technicianImageUrl = data['imageUrl'];
        technicianName = data['name'] ?? 'Unknown';
        technicianPhone = data['phone'] ?? 'Not available';
      });
    }
  }

  void _listenToTechnicianLocation() {
    _techSubscription = FirebaseFirestore.instance
        .collection('technicians')
        .doc(widget.technicianId)
        .snapshots()
        .listen((snapshot) async {
          final data = snapshot.data();
          if (data != null && data['location'] != null) {
            final loc = data['location'];
            final newTechLoc = LatLng(loc['lat'], loc['lng']);

            setState(() {
              _technicianLocation = newTechLoc;
            });

            await _updateMap();
            await _drawRouteAndCalculateETA();

            // ✅ تنبيه لو الفني قرب لمسافة 200م أو أقل
            if (_distanceText.isNotEmpty) {
              final distanceValue =
                  double.tryParse(_distanceText.split(' ').first) ?? 0;
              if (distanceValue <= 0.2) {
                _showArrivalAlert();
              }
            }
          }
        });
  }

  void _listenToRequestStatus() {
    _requestSubscription = FirebaseFirestore.instance
        .collection('requests')
        .doc(widget.requestId)
        .snapshots()
        .listen((snapshot) {
          final data = snapshot.data();
          if (data != null && data['status'] == 'arrived') {
            Get.offAll(
              () => SelectCustomerIssuesPage(requestId: widget.requestId),
            );
          }
        });
  }

  Future<void> _updateMap() async {
    if (_technicianLocation == null) return;

    _markers = {
      Marker(
        markerId: const MarkerId('user'),
        position: widget.userLocation,
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId('technician'),
        position: _technicianLocation!,
        infoWindow: InfoWindow(title: technicianName),
      ),
    };

    if (_mapController != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          min(widget.userLocation.latitude, _technicianLocation!.latitude),
          min(widget.userLocation.longitude, _technicianLocation!.longitude),
        ),
        northeast: LatLng(
          max(widget.userLocation.latitude, _technicianLocation!.latitude),
          max(widget.userLocation.longitude, _technicianLocation!.longitude),
        ),
      );
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }

    setState(() {});
  }

  Future<void> _drawRouteAndCalculateETA() async {
    if (_technicianLocation == null) return;

    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_technicianLocation!.latitude},${_technicianLocation!.longitude}&destination=${widget.userLocation.latitude},${widget.userLocation.longitude}&key=$googleApiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data["routes"].isNotEmpty) {
      final route = data["routes"][0];
      final points = _decodePolyline(route["overview_polyline"]["points"]);

      final leg = route["legs"][0];
      setState(() {
        _distanceText = leg["distance"]["text"];
        _etaText = leg["duration"]["text"];
        _polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            points: points,
            color: Colors.blue,
            width: 6,
          ),
        };
      });
    }
  }

  void _showArrivalAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Technician is nearby (within 200 meters)!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polylinePoints.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylinePoints;
  }

  void _callTechnician(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _whatsappTechnician(String phone) async {
    // تنظيف الرقم وإزالة أي رموز غير أرقام
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // تأكد أن الرقم يبدأ بكود الدولة
    if (!cleanPhone.startsWith('2')) {
      // مثال مصر
      cleanPhone = '2$cleanPhone';
    }

    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تعذر فتح تطبيق واتساب."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Technician Tracking")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.userLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundImage: technicianImageUrl != null
                        ? NetworkImage(technicianImageUrl!)
                        : null,
                    backgroundColor: Colors.grey[200],
                    child: technicianImageUrl == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  title: Text(
                    technicianName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(technicianPhone),
                  trailing: IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: technicianPhone != 'Not available'
                        ? () => _callTechnician(technicianPhone)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: technicianPhone != 'Not available'
                      ? () => _whatsappTechnician(technicianPhone)
                      : null,
                  icon: const Icon(Icons.message),
                  label: const Text("Message on WhatsApp"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 10),
                if (_etaText.isNotEmpty && _distanceText.isNotEmpty)
                  Text(
                    "🚗 ETA: $_etaText | Distance: $_distanceText",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 8),
                const Text(
                  "Tracking technician in real-time...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
