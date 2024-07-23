import 'dart:convert';

import 'package:coastal/screens/main_class.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _residentialAddressController = TextEditingController();
  final TextEditingController _countFamilyMembersController = TextEditingController();
  final TextEditingController _locationOfRequestController = TextEditingController();
  final TextEditingController _countOfRequestsController = TextEditingController();
  final TextEditingController _requestedResourcesController = TextEditingController();
  String _errorMessage = '';
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Future<void> _login() async {
    try {


      String? fcmToken = await _messaging.getToken();
      Location location = new Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw Exception('Failed to enable location services');
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission not granted');
        }
      }

      _locationData = await location.getLocation();

      var response = await http.post(
        Uri.parse('https://mustang-helpful-lively.ngrok-free.app/api/admin/addUser'), // Change to your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
          'fcm_token': fcmToken ?? '',
          'latitude': _locationData.latitude.toString(),
          'longitude': _locationData.longitude.toString(),
          'name': _nameController.text,
          'age': _ageController.text,
          'residentialAddress': _residentialAddressController.text,
          'countFamilyMembers': _countFamilyMembersController.text,
        }),
      );
      var responseBody = jsonDecode(response.body);
      print(responseBody);

      // Store UID in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', fcmToken ?? '');
      String userId = responseBody['user']?['user_id'] ?? '';  // Using the null-aware operator to handle potential nulls
// Storing the token
      await prefs.setString('user_id', userId ?? '');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await prefs.setString('uid', userCredential.user?.uid ?? '');

     await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));

      print("User logged in: ${userCredential.user?.email}");
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                isPassword: false,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: 10),

              // Additional fields here:
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                isPassword: false,
              ),
              SizedBox(height: 10),

              _buildTextField(
                controller: _ageController,
                label: 'Age',
                icon: Icons.calendar_today,
                isPassword: false,
              ),
              SizedBox(height: 10),

              _buildTextField(
                controller: _residentialAddressController,
                label: 'Residential Address',
                icon: Icons.home,
                isPassword: false,
              ),
              SizedBox(height: 10),

              _buildTextField(
                controller: _countFamilyMembersController,
                label: 'Count of Family Members',
                icon: Icons.family_restroom,
                isPassword: false,
              ),
              SizedBox(height: 10),




              SizedBox(height: 40),
              ElevatedButton(
                onPressed:()async{
                  await _login();
                } ,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue),
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: isPassword,
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }
}
