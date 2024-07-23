import 'package:coastal/provider/auth_provider.dart';
import 'package:coastal/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:coastal/utils/NotificationManager.dart';
import 'package:coastal/utils/global_context.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'home_page.dart';

import 'package:just_audio/just_audio.dart';

Future<void> playAudioForTenSeconds() async {
  // Create a new instance of the audio player
  final AudioPlayer audioPlayer = AudioPlayer();

  try {
    // Load the audio from the provided URL
    audioPlayer.setAsset('assets/buzzers.mp3');

    // Play the audio
    await audioPlayer.play();

    // Wait for 10 seconds
    await Future.delayed(Duration(seconds: 10));

    // Stop the audio after 10 seconds
    await audioPlayer.stop();
  } catch (e) {
    // Handle potential errors, e.g., audio source not found, connection issues
    print('Error playing audio: $e');
  } finally {
    // Always release the player to free up resources
    await audioPlayer.dispose();
  }
}

void showLocalNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (notification != null && android != null) {

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'E Drives Notification Channel',
          importance: Importance.max,
          icon:
          '@mipmap/launcher_icon', // Ensure this icon is available in your project
        ),
      ),
    );
  }
  else {

    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification!.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'E Drives Notification Channel',
          importance: Importance.max,
          icon: '@mipmap/launcher_icon', // Ensure this icon is available in your project
        ),
      ),
    );
    playAudioForTenSeconds();

  }
  playAudioForTenSeconds();

}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showLocalNotification(message);
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showLocalNotification(message);

    });
  // FlutterGemmaPlugin.instance.init(
  //   maxTokens: 512,
  //   temperature: 1.0,
  //   topK: 1,
  //   randomSeed: 1,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  String? initialMessage;
  bool _resolved = false;

  @override



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey:  NavigationService.navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      navigatorObservers: [NavigationHistoryObserver()],
      home: const MyApp1(),
    );
  }
}



class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Poppins',
            ),
            home: const SplashScreen()),
      ),
    );
  }
}

