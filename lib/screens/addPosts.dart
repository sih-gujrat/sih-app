import 'dart:io';

import 'package:coastal/helpers/validators.dart';
import 'package:coastal/provider/post_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  static var _isInit = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
    ///  Provider.of<Profile>(context, listen: false).getProfile();

      setState(() {
        _isInit = false;
      });
    }
  }

  @override
  void dispose() {
    setState(() {
      _isInit = true;
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int index = 0;
   var data = Provider.of<PostProvider>(context);

    _settingModalBottomSheet() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SizedBox(
              height: 150,
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Camera'),
                      onTap: () async {
                        Navigator.pop(context);
                        final pickedFile = await _picker.pickImage(
                            source: ImageSource.camera,
                            maxHeight: 500,
                            maxWidth: 500,
                            imageQuality: 50);

                        await data.uploadProfileImage( pickedFile!.path);
                      }),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Navigator.pop(context);
                      final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 500,
                          maxWidth: 500,
                          imageQuality: 50);

                      await data.uploadProfileImage(pickedFile!.path);
                    },
                  ),
                ],
              ),
            );
          });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                          height: 100,
                          width: 115,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    _settingModalBottomSheet();
                                  },
                                  child: data.image.isEmpty
                                      ? ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                        image: Image.asset('assets/My Picture.png').image,
                                      ))
                                      : ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child:  Image.file(
                                      File(data.image),
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 120,
                                    ),

                                  )

                              ),
                            ],
                          )
                      ),
                    ]),
                            SizedBox(height: 20,),

                            Padding(
                              padding: const EdgeInsets.only(right: 20, left: 20),

                              child: TextFormField(
                                controller: data.descriptionController,

                                style: GoogleFonts.nunitoSans(),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),

                                    hintText: "Desciption",
                                    hintStyle: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black38),
                                    fillColor: Colors.black12,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                    SizedBox(height: 20,),
                    Center(
                      child: Container(width: width/2,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                            data.uploadPoasts(context);

                          },
                          child: const Text(
                            "Confirm",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xfff6e80b),
                              fontSize: 12,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                          ],
                        ),
            )),


        ));
  }
}
