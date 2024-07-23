import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class HomeViewModel extends ChangeNotifier {
  final kInitialPosition = CameraPosition(
      target: LatLng(20.5937, 78.9629),
      zoom: 4); // Center of India for demonstration
  bool isBusy = false;
  final Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _userLocation;
  Set<Marker> markers = {};
  bool _shouldShowPrompt = false; // Add this line
  TextEditingController waterController = TextEditingController();
  TextEditingController clothingController = TextEditingController();
  TextEditingController foodController = TextEditingController();
  TextEditingController medicalController = TextEditingController();
  String? userId = '';
  // Getter for _shouldShowPrompt
  bool get shouldShowPrompt => _shouldShowPrompt;
  Future<void> futureToRun() async {
    isBusy = true;
    notifyListeners();
    await fetchAndSetMarkers();
    await _determinePosition();
    await checkProximity();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');

    isBusy = false;
    notifyListeners();
  }

  Future<BitmapDescriptor> getNetworkImageAsMarker(String url,
      {int width = 100, int height = 100}) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        img.Image image = img.decodeImage(bytes)!;

        img.Image resized = img.copyResize(image, width: width, height: height);

        bytes = Uint8List.fromList(img.encodePng(resized));

        return BitmapDescriptor.fromBytes(bytes);
      } else {
        print('HTTP error with status code: ${response.statusCode}');
        throw Exception(
            'Failed to load marker image due to HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught while fetching or processing the image: $e');
      throw Exception('Failed to load marker image: $e');
    }
  }

  Future<String> getCityFromLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service is disabled.');
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission not granted.');
      }
    }

    LocationData locationData = await location.getLocation();

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );

    // Assuming the first returned Placemark is the most accurate one
    geo.Placemark place = placemarks[0];
    return place.locality ?? "Unknown city"; // locality is the city
  }

  Future<void> fetchAndSetMarkers() async {
    var volunteerCenters = await fetchData(
        'https://01707xbim6.execute-api.ap-south-1.amazonaws.com/api/admin/getVolunteerCenters');
    var safeSpots = await fetchData(
        'https://01707xbim6.execute-api.ap-south-1.amazonaws.com/api/admin/getSafeSpots');
    var disasters = await fetchData(
        "https://mustang-helpful-lively.ngrok-free.app/api/admin/getAllDisasters");
    Set<Marker> newMarkers = {};
    volunteerCenters.forEach((center) {
      // Convert integer coordinates to double if needed
      double lat = center['location']['coordinates'][1].toDouble();
      double lng = center['location']['coordinates'][0].toDouble();

      newMarkers.add(Marker(
        markerId: MarkerId(center['_id']),
        position: LatLng(lat, lng),
        infoWindow:
            InfoWindow(title: center['name'], snippet: 'Volunteer Center'),
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
    for (var disaster in disasters) {
      double lat = disaster['location']['latitude'].toDouble();
      double lng = disaster['location']['longitude'].toDouble();
      String imageUrl =
          'https://mustang-helpful-lively.ngrok-free.app/uploads/${disaster['singleFile']}';
      print(imageUrl);

      // Asynchronously set the custom marker icon with the image
      // final BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      //     ImageConfiguration(size: Size(48, 48)), imageUrl);
      BitmapDescriptor icon = await getNetworkImageAsMarker(imageUrl);

      newMarkers.add(Marker(
        markerId: MarkerId(disaster['_id']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: disaster['type'].toUpperCase(),
            snippet: 'Year: ${disaster['Year']}'),
        icon: icon,
      ));
    }

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

  Future<void> sendResourceRequest(
      String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Resource request successful: ${response.body}');
    } else {
      throw Exception(
          'Failed to send resource request: ${response.statusCode}');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    // Custom map creation logic or controller setting can be added here
  }

  Future<void> _determinePosition() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _userLocation = await location.getLocation();
  }

  Future<void> checkProximity() async {
    const double maxDistance = 50000; // 50 km
    bool foundCloseMarker = false;

    for (var marker in markers) {
      double distance = _calculateDistance(
        _userLocation.latitude!,
        _userLocation.longitude!,
        marker.position.latitude,
        marker.position.longitude,
      );

      if (distance <= maxDistance) {
        foundCloseMarker = true;
        break;
      }
    }

    if (foundCloseMarker != _shouldShowPrompt) {
      _shouldShowPrompt = foundCloseMarker;
      notifyListeners();
    }
  }
}

double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  var p = 0.017453292519943295; // Pi/180
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}
