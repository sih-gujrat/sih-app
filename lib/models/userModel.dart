import 'dart:convert';

import 'package:flutter/cupertino.dart';

class userModel with ChangeNotifier {
  userModel({
    required this.name,
    required this.institute_id,
    required this.city_id,
    required this.branch,
    required this.stream,
    required this.emailAddress,
    required this.gender,
    required this.semester,
    required this.password,
    required this.date,
  });

  String name;
  String date;
  String emailAddress;
  String password;
  String semester;
  String stream;
  String branch;
  String city_id;
  String institute_id;
  String gender;
}
