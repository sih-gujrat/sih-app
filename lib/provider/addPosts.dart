import 'dart:convert';

import 'package:coastal/repo/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Profile with ChangeNotifier {

  bool status = true;
  String email = '';
  String login_type = '';
  String gimage = "";
  String gid = "";
  bool _isLoading = false;
  bool profileImageFromAPi = false;
  int index = 0;
  bool nameError = false;


  bool get isLoading => _isLoading;

  final HomeRepository _homeRepo = HomeRepository();

  HomeRepository get homeRepo => _homeRepo;









  uploadProfileImage(String type, String filepath) async {
     // ProfileModel.image = filepath;
      //editProfileImage();
      profileImageFromAPi = false;



    notifyListeners();
  }


}
