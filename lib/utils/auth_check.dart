
import 'package:coastal/provider/auth_provider.dart';
import 'package:coastal/provider/mapu_view.dart';
import 'package:coastal/provider/post_model.dart';
import 'package:coastal/provider/register_provider.dart';
import 'package:coastal/provider/upload_file.dart';
import 'package:coastal/repo/repo.dart';
import 'package:coastal/screens/main_class.dart';
import 'package:coastal/screens/slider.dart';
import 'package:coastal/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';



class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));
    return MultiProvider(
      providers: [

        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),


        ChangeNotifierProxyProvider<AuthProvider, FileUploadProvider>(
          create: (ctx) => FileUploadProvider(),
          update: (ctx,auth,_) => FileUploadProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, PostProvider>(
          create: (ctx) => PostProvider(),
          update: (ctx,auth,_) => PostProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, HomeViewModel>(
          create: (ctx) => HomeViewModel(),
          update: (ctx,auth,_) => HomeViewModel(),
        ),

        ChangeNotifierProxyProvider<AuthProvider, RegisterProvider>(
                  create: (ctx) => RegisterProvider('',''),
                   update: (ctx,auth,_) => RegisterProvider('',''),
                 ),

        ChangeNotifierProxyProvider<AuthProvider, DataProvider>(
          create: (ctx) => DataProvider(),
          update: (ctx,auth,_) => DataProvider(),
        ),


      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp
          (
          debugShowCheckedModeBanner: false,

          title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              brightness: Brightness.light,
              fontFamily: 'medium',
            ),
            home: auth.isAuth
                ? const MainScreen()
                : FutureBuilder(
                  //  future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? const SplashScreen() :  MainScreen(), future: null,
                  ),
            //routes: {
          //               Login.routeName:(context)=>Login(),
          //             About.routeName: (context) => const About(),
          //
          //             }
           ),
      ),
    );
  }
}
