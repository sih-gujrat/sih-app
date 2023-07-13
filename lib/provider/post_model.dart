
import 'package:coastal/repo/home_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final url = 'https://ggy7td6r07.execute-api.us-east-1.amazonaws.com/api/client/getposts';

class Post {
  final String latitude;
  final String longitude;
  final String time;
  final String filenames;
 // final String genuine;
  final String pid;

  Post({
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.filenames,
   // required this.genuine,
    required this.pid,
  });
}

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;
  final HomeRepository _homeRepo = HomeRepository();

  HomeRepository get homeRepo => _homeRepo;
  final TextEditingController _locationController = TextEditingController();
  TextEditingController get locationController => _locationController;


  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;


  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;


  // description

String image = '';

  uploadProfileImage( String filepath) async {
    image = filepath;



    notifyListeners();
  }


  Future<void> fetchPosts() async {
    Dio dio = Dio();
    try {
      final response1 = await dio.get(url);

      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> postList = responseData['all_posts'];
        _posts = postList.map((postData) =>
            Post(
              latitude: postData['latitude'],
              longitude: postData['longitude'],
              time: postData['time'],
              filenames: postData['filenames'],
              //genuine: postData['genuine'],
              pid: postData['pid'],
            )).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch posts');
      }
    } catch (error) {
      print(error.toString());
    }
  }


  uploadPoasts(BuildContext context) async {
    await _homeRepo.posts(descriptionController.text,image)
        .then((response) async {
          print("image = ============="+image);
      final responseData = json.decode(response);
      print(responseData);
        _showDialog(responseData["message"], context);

        // prefs.setString('_id', _id);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));

    });

    notifyListeners();
  }


  void _showDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: const Text('Coastal!'),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      const Size.fromHeight(40.0)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                child: const Text('Okay'),
                onPressed: () {
                  notifyListeners();
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
    );
  }

}
