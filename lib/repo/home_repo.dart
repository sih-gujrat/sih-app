import 'dart:convert';
import 'package:coastal/utils/url.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeRepository {



  Future<String> posts(String description,String profileImage) async {
    var url = Uri.parse('https://ggy7td6r07.execute-api.us-east-1.amazonaws.com/api/admin/upload'); // Replace with your API endpoint
    try{
      DateTime now = DateTime.now();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    // Create the multipart request
    var request = http.MultipartRequest('POST', url);
    request.files.add(
        await http.MultipartFile.fromPath('image', profileImage));
    // Add the body parameters
    request.fields['description'] = description; // Replace with the actual value
    request.fields['latitude'] ="${position.latitude}"; // Replace with the actual value
    request.fields['longitude'] = "${position.longitude}"; // Replace with the actual value
    request.fields['time'] = '$now.month'; // Replace with the actual value


    var res = await request.send();
    final respStr = await res.stream.bytesToString();

    return respStr;
  } catch (error) {
  print(error);
  rethrow;
  }
}






  Future<String> login(
    String emailAddress,
    String password,
  ) async {
    final url = Uri.parse(URL.url + 'client/login');
    print(url);
    try {
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "emailAddress": emailAddress,
            "password": password,
          }));

      print(url);

      return response.body;
    } catch (error) {
      throw (error);
    }
  }


}
