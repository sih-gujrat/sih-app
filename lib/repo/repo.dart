
import 'package:coastal/constants/string_constants.dart';
import 'package:coastal/model/place_model/place_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:math';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin,sin,pi;

class Repo {
  Repo._();
  static Future<PredictionModel?> placeAutoComplete(
      {required String placeInput}) async {
    try {
      Map<String, dynamic> querys = {
        'input': placeInput,
        'key': AppString.googleMapApiKey
      };
      final url = Uri.https(
          "maps.googleapis.com", "maps/api/place/autocomplete/json", querys);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return PredictionModel.fromJson(jsonDecode(response.body));
      } else {
        response.body;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }
  static double calculateDistance(PointLatLng point1, PointLatLng point2) {
    const double earthRadius = 6371.0; // Earth's radius in kilometers
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * asin(sqrt(a));

    double distance = earthRadius * c;
    return distance;
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180);
  }


  static Future<List<PointLatLng>> getRouteBetweenTwoPoints({
    required LatLng start,
    required LatLng end,
    required LatLng avoidLocation,
    required List<Color> colors,
  }) async {
    List<PointLatLng> routePoints = [];
    int colorIndex = 0;

    // Call the Google Maps Directions API
    String apiKey = "AIzaSyCAtulI2D7MUuz6WZ8e1EqBs_DlWLK_mWw";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["status"] == "OK") {
        List<dynamic> routes = data["routes"];
        if (routes.isNotEmpty) {
          List<dynamic> legs = routes[0]["legs"];
          if (legs.isNotEmpty) {
            List<dynamic> steps = legs[0]["steps"];
            for (var step in steps) {
              String polyline = step["polyline"]["points"];
              List<PointLatLng> decodedPolyline = decodePolyline(polyline);

              // Check if the avoidLocation is near the original route
              double avoidRange = 10; // Adjust the range as per your requirement
              bool avoidLocationNearRoute = isLocationNearRoute(
                  avoidLocation, decodedPolyline, avoidRange);

              if (avoidLocationNearRoute) {
                // Find a different navigation passage
                LatLng alternateEnd =
                findAlternateEnd(avoidLocation, decodedPolyline);

                // Call the Google Maps Directions API again with the alternate end
                String alternateUrl =
                    "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${alternateEnd.latitude},${alternateEnd.longitude}&key=$apiKey";

                http.Response alternateResponse =
                await http.get(Uri.parse(alternateUrl));

                if (alternateResponse.statusCode == 200) {
                  Map<String, dynamic> alternateData =
                  json.decode(alternateResponse.body);
                  if (alternateData["status"] == "OK") {
                    List<dynamic> alternateRoutes = alternateData["routes"];
                    if (alternateRoutes.isNotEmpty) {
                      List<dynamic> alternateLegs =
                      alternateRoutes[0]["legs"];
                      if (alternateLegs.isNotEmpty) {
                        List<dynamic> alternateSteps =
                        alternateLegs[0]["steps"];
                        for (var alternateStep in alternateSteps) {
                          String alternatePolyline =
                          alternateStep["polyline"]["points"];
                          List<PointLatLng> alternateDecodedPolyline =
                          decodePolyline(alternatePolyline);

                          routePoints.addAll(alternateDecodedPolyline);
                        }
                      }
                    }
                  }
                }
              } else {
                // Filter out points that fall within the specified range of the avoidLocation
                List<PointLatLng> filteredPoints = decodedPolyline.where((point) {
                  double distanceToAvoid = calculateDistance(
                      point, PointLatLng(avoidLocation.latitude, avoidLocation.longitude));
                  return distanceToAvoid > avoidRange;
                }).toList();

                // Add filtered points with the current color to the routePoints
                for (var point in filteredPoints) {
                  routePoints.add(point);
                }

                // Increment the color index and wrap around if it exceeds the number of colors
                colorIndex = (colorIndex + 1) % colors.length;
              }
            }
          }
        }
      }
    }

    return routePoints;
  }


  static bool isLocationNearRoute(LatLng location, List<PointLatLng> routePoints, double range) {
    for (var point in routePoints) {
      double distance = calculateDistance(PointLatLng(location.latitude, location.longitude), point);
      if (distance <= range) {
        return true;
      }
    }
    return false;
  }

  static LatLng findAlternateEnd(LatLng avoidLocation, List<PointLatLng> routePoints) {
    double maxDistance = 0;
    LatLng alternateEnd = avoidLocation;

    for (var point in routePoints) {
      double distance = calculateDistance(PointLatLng(avoidLocation.latitude, avoidLocation.longitude), point);
      if (distance > maxDistance) {
        maxDistance = distance;
        alternateEnd = LatLng(point.latitude, point.longitude);
      }
    }

    return alternateEnd;
  }

  static List<PointLatLng> decodePolyline(String encodedPolyline) {
    List<PointLatLng> polylinePoints = [];

    int index = 0;
    int len = encodedPolyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int byte;

      do {
        byte = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        byte = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1e5;
      double longitude = lng / 1e5;

      polylinePoints.add(PointLatLng(latitude, longitude));
    }

    return polylinePoints;
  }
}



class DataModel {
  final String intensity;
  final String latitude;
  final String longitude;

  DataModel({
    required this.intensity,
    required this.latitude,
    required this.longitude,
  });


}





class DataProvider extends ChangeNotifier {
  List<DataModel> _items = [];

  List<DataModel> get items => _items;
fetchData() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://ec2-13-232-165-154.ap-south-1.compute.amazonaws.com:5000/data/latest');
      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);
        final intensity = responseData['intensity'];
        final latitude = responseData['latitude'];
        final longitude = responseData['longitude'];

        _items = [
          //DataModel(intensity: "", latitude: "77.6221", longitude: "13.0448"),
          DataModel(intensity: intensity, latitude: latitude, longitude: longitude),
        ];

        notifyListeners();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }
}
