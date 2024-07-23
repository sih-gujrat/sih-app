import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
class FileUploadProvider with ChangeNotifier{
  final String uploadUrl = 'https://mustang-helpful-lively.ngrok-free.app';
  int generateRandomIntensity() {
    final random = Random();
    return random.nextInt(10) + 1; // nextInt(10) generates a number between 0 and 9, so add 1 to shift it to 1-10
  }
  Future<void> uploadFile({required File file}) async {
    try {
      var uri = Uri.parse('$uploadUrl/api/admin/createDisaster');
      var request = http.MultipartRequest('POST', uri);

      // Correct MIME type detection and file stream preparation
      String mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      var fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
      var length = await file.length();

      // Creating and adding the multipart file
      var multipartFile = http.MultipartFile(
          'singleFile',
          fileStream,
          length,
          filename: basename(file.path),
          contentType: MediaType.parse(mimeType)
      );
      request.files.add(multipartFile);

      // Continue with the location and date-time processing
      Location location = new Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw 'Location services are disabled.';
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          throw 'Location permissions are denied';
        }
      }

      _locationData = await location.getLocation();

      // Get current date and time
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      final randomIntensity = generateRandomIntensity();

      // Attach additional fields
      request.fields['Year'] = now.year.toString();
      request.fields['Month'] = now.month.toString();
      request.fields['Day'] = now.day.toString();
      request.fields['location[latitude]'] = _locationData.latitude.toString();
      request.fields['location[longitude]'] = _locationData.longitude.toString();
      request.fields['location[intensity]'] = randomIntensity.toString();

      var response = await request.send();

      if (response.statusCode == 201) {
        print("File uploaded successfully");
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}

//