import 'dart:convert';

import 'package:flutter/cupertino.dart';

class TypeModel with ChangeNotifier {
  TypeModel({
    required this.tid,
    required this.title,
    required this.description,
    required this.profile_pic_filename,
  });

  String tid;
  String title;
  String description;
  List<dynamic> profile_pic_filename;
}
