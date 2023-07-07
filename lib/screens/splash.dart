import 'dart:async';


import 'package:coastal/helpers/routing.dart';
import 'package:coastal/utils/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        fontFamily: ('FututraBold'),
        primarySwatch: Colors.green,
      ),
      home: const Splash2(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  _Splash2 createState() => _Splash2();
}

class _Splash2 extends State<Splash2> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () =>  Navigator.pushReplacement(context, SlidePageRoute( page: AuthCheck())));

  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    const Color black = Color(0xFF000000);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Colors.white,
            Colors.blue
          ]
        )
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
                child: Center(
                  child: Image(
                    image: Image.asset('assets/bkg.png').image,
                    height: height/2,
                    width: width,
                    fit: BoxFit.contain,
                  ),
                )),
          )),
    );
  }
}
