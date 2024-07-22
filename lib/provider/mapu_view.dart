import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends ChangeNotifier {
  final kInitialPosition = CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 4); // Center of India for demonstration
  bool isBusy = false;
  Set<Marker> markers = {};

  Future<void> futureToRun() async {
    isBusy = true;
    notifyListeners();
    await fetchAndSetMarkers();
    isBusy = false;
    notifyListeners();
  }

  Future<void> fetchAndSetMarkers() async {
    var volunteerCenters = await fetchData('https://01707xbim6.execute-api.ap-south-1.amazonaws.com/api/admin/getVolunteerCenters');
    var safeSpots = await fetchData('https://01707xbim6.execute-api.ap-south-1.amazonaws.com/api/admin/getSafeSpots');

    Set<Marker> newMarkers = {};
    volunteerCenters.forEach((center) {
      // Convert integer coordinates to double if needed
      double lat = center['location']['coordinates'][1].toDouble();
      double lng = center['location']['coordinates'][0].toDouble();

      newMarkers.add(Marker(
        markerId: MarkerId(center['_id']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: center['name'], snippet: 'Volunteer Center'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });

    safeSpots.forEach((spot) {
      // Convert integer coordinates to double if needed
      double lat = spot['location']['coordinates'][1].toDouble();
      double lng = spot['location']['coordinates'][0].toDouble();

      newMarkers.add(Marker(
        markerId: MarkerId(spot['_id']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: spot['name'], snippet: 'Safe Spot'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });

    markers = newMarkers;
  }


  Future<List<dynamic>> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    // Custom map creation logic or controller setting can be added here
  }
}
