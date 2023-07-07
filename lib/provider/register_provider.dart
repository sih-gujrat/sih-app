import 'dart:convert';
import 'package:coastal/repo/home_repo.dart';
import 'package:coastal/screens/main_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

class RegisterProvider with ChangeNotifier {
  final HomeRepository _homeRepo = HomeRepository();
  HomeRepository get homeRepo => _homeRepo;

  RegisterProvider(this._public_key, this._private_key);

  String _public_key;

  String get public_key => _public_key;

  String _private_key;

  String get private_key => _private_key;

  Future<void> retrieveDataFromSharedPreferences() async {
    // Retrieve the value of 'course_id' from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _public_key = prefs.getString('public_key')!;
    _private_key = prefs.getString('private_key')!;

    // Notify listeners that the value(s) have changed
    notifyListeners();
  }


  List<InsuranceStatus> _insurances = [];
  List<InsuranceStatus> get insurances {
    return [..._insurances];
  }


  String gender = "Select Gender";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  TextEditingController get nameController => _nameController;
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _stateController = TextEditingController();
  TextEditingController get stateController => _stateController;

  final TextEditingController _cityController = TextEditingController();
  TextEditingController get cityController => _cityController;

  TextEditingController get emailController => _emailController;
  String profileImage = '';
  String user = 'Teacher';
  String city_id = "0";
  bool nameError = false;
  bool emailError = false;
  bool cityNameError = false;
  bool _isLoading = false;
  bool passwordError = false;

  bool get isLoading => _isLoading;

  // getCity() async {
  //      _CityItems = [];
  //      _CityItems.add(cityModel(id: "0", name: "Select City"));
  //      await _homeRepo.fetchAndSetCity().then((response) {
  //        final responseData = json.decode(response);
  //        responseData['cities'].forEach((prodData) {
  //          _CityItems.add(cityModel(id: prodData['city_id'], name: prodData['name']));
  //        });
  //      });
  //
  //      notifyListeners();
  //    }
  String policyId = '';
  void updatepolicyid(String value, BuildContext context) {
    policyId = value;
    notifyListeners();
    BuyInsuance(context);
  }

  void updateUserType(String value) {
    user = value;
    notifyListeners();
  }

  void updateGender(String value) {
    gender = value;
    notifyListeners();
  }

  uploadProfileImage(String filepath) async {
    profileImage = filepath;
    notifyListeners();
  }

//  getInstitute() async {
//     _IntItems = [];
//     _IntItems.add(instituteModel(
//       id: "0",
//       name: "Select Institute",
//     ));
//
//     await _homeRepo.fetchAndSetInstitute(city_id).then((response) {
//       final responseData = json.decode(response);
//       responseData['inst'].forEach((prodData) {
//         _IntItems.add(
//             instituteModel(id: prodData['_id'], name: prodData['name']));
//       });
//     });
//
//     notifyListeners();
//   }

  register(BuildContext context) async {
    // Create a new http client
    var client = http.Client();

    try {
      // Define the endpoint URL
      var url = Uri.parse('http://34.125.247.127:9080/baby_chain/private/node');

      // Define the request body
      var requestBody = jsonEncode({
        "name": nameController.text,
        "email": nameController.text,
        "gender": gender,
        "password": passwordController.text,
        "state": stateController.text,
        "city": cityController.text
      });

      // Define the request headers
      var headers = {'Content-Type': 'application/json'};

      // Create a new http POST request with the defined URL, headers and body
      var response = await client.post(
        url,
        headers: headers,
        body: requestBody,
      );

      // Check if the response contains cookies
      if (response.headers.containsKey('set-cookie')) {
        // Extract the cookies from the response headers
        var cookies = response.headers['set-cookie'];

        // Store the cookies for later use
        // You can store the cookies in a CookieJar or in SharedPreferences
        // Here, we are just printing the cookies for demonstration purposes
        print('Received cookies: $cookies');
      }

      // Handle the response body
      if (response.statusCode == 200) {
        var responseBody = response.body;
        final responseData = json.decode(response.body);
        print(responseData);
        _public_key = responseData['public_key'];
        _private_key = responseData['private_key'];
        await SharedPreferences.getInstance().then((prefs) {
          // prefs.setString('_id', _id);
          prefs.setString('public_key', _public_key);
          prefs.setString('private_key', _private_key);
          _showDialog("Succesfully registered the User", context);
        });
        print(responseBody);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error making POST request: $error');
    } finally {
      // Close the client
      client.close();
    }
  }


  UserStatus(BuildContext context) async {
    // Create a new http client
    var client = http.Client();
    try {
      // Define the endpoint URL
      var url =
          Uri.parse('http://34.125.247.127:9080/baby_chain/private/status');

      // Define the request body
      print(_public_key);
      final headers = {'Content-Type': 'application/json'};

      final body = json.encode({"user_id": _public_key});
      final response = await http.post(url, headers: headers, body: body);
      print(body);

      if (response.statusCode == 200) {
        _insurances= [];
        final Map<String, dynamic> responseData = json.decode(response.body) ?? {};
        final List<dynamic> insuranceList = responseData['Array'];
        print(insuranceList);
        insuranceList.forEach((prodData) {
          _insurances.add(InsuranceStatus(
              claimSuccessPercentage: prodData['claim_success_percentage'],
              companyName: prodData['company_name'],
              coverageValue: prodData['coverage_value'],
              description: prodData['description'],
              insuranceName: prodData['insurance_name'],
              launchDate: prodData['launch_date'],
              monthlyCost: prodData['monthly_cost'],
              otherDetails: prodData['other_details'],
              publicKey: prodData['public_key'],
              type: prodData['type']));
        }

    );
        print(_insurances[0].insuranceName);

      } else {
        print('Error : ${response.statusCode}');
      }

    } catch (error) {
      print('Error : $error');
    }
  }

  BuyInsuance(BuildContext context) async {
    // Create a new http client
    var client = http.Client();

    try {
      // Define the endpoint URL
      var url =
          Uri.parse('http://34.125.247.127:9080/baby_chain/private/buy_ins');

      // Define the request body
      var requestBody = jsonEncode({
        "public_key": _public_key,
        "private_key": _private_key,
        "policy_ref_id": policyId,
      });

      // Define the request headers
      var headers = {'Content-Type': 'application/json'};
      print(requestBody);

      // Create a new http POST request with the defined URL, headers and body
      var response = await client.post(
        url,
        headers: headers,
        body: requestBody,
      );

      // Check if the response contains cookies
      if (response.headers.containsKey('set-cookie')) {
        // Extract the cookies from the response headers
        var cookies = response.headers['set-cookie'];

        // Store the cookies for later use
        // You can store the cookies in a CookieJar or in SharedPreferences
        // Here, we are just printing the cookies for demonstration purposes
        print('Received cookies: $cookies');
        print(response.body);
      }

      // Handle the response body
      if (response.statusCode == 200) {
        var responseBody = response.body;
        final responseData = json.decode(response.body);
        print(responseData);

        print(responseBody);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error making POST request: $error');
    } finally {
      // Close the client
      client.close();
    }
  }

  void _showDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Insurego!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size.fromHeight(40.0)),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            child: const Text('Okay'),
            onPressed: () {
              nameController.text = "";
              emailController.text = "";
              passwordController.text = "";
              gender = "Select Gender";

              cityController.text = "";
              stateController.text = "";

              notifyListeners();
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
          )
        ],
      ),
    );
  }
}

// Modal class

class InsuranceStatus {
  final String claimSuccessPercentage;
  final String companyName;
  final String coverageValue;
  final String description;
  final String insuranceName;
  final String launchDate;
  final String monthlyCost;
  final String otherDetails;
  final String publicKey;
  final String type;

  InsuranceStatus({
    required this.claimSuccessPercentage,
    required this.companyName,
    required this.coverageValue,
    required this.description,
    required this.insuranceName,
    required this.launchDate,
    required this.monthlyCost,
    required this.otherDetails,
    required this.publicKey,
    required this.type,
  });
}

//
//
//
// void main() async {
//   final url = Uri.parse('http://34.125.247.127:9080/baby_chain/private/status');
//   final headers = {'Content-Type': 'application/json'};
//   final body = json.encode({"user_id":"473eac29954ab9d93a0e8b9980e0d83d08d2853855daa54610d4246736a828c7"});
//   final response = await http.post(url, headers: headers, body: body);
//   if (response.statusCode == 200) {
//     final responseData = json.decode(response.body);
//     final List<dynamic> insuranceData = responseData['Array'];
//     final List<Insurance> insurances = insuranceData
//         .map((data) => Insurance.fromJson(data))
//         .toList();
//     // Do something with the list of insurances here
//     print(insurances);
//   } else {
//     print('Error making POST request: ${response.statusCode}');
//   }
// }
//
