import 'dart:math';

import 'package:coastal/screens/Articles%20-%20SafeCarousel/AllArticles.dart';
import 'package:coastal/screens/Articles%20-%20SafeCarousel/SafeCarousel.dart';
import 'package:coastal/screens/Emergency.dart';
import 'package:coastal/screens/LiveSafeSpots/BusStationCard.dart';
import 'package:coastal/screens/LiveSafeSpots/HospitalCard.dart';
import 'package:coastal/screens/LiveSafeSpots/PharmacyCard.dart';
import 'package:coastal/screens/LiveSafeSpots/PoliceStationCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int quoteIndex = 0;
  String? userId;

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
      print(userId);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
    getRandomInt(false);
  }

  getRandomInt(fromClick) {
    Random rnd = Random();

    quoteIndex = rnd.nextInt(4);
    if (mounted && fromClick) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DashAppbar(
        //   getRandomInt: getRandomInt,
        //   quoteIndex: quoteIndex,
        // ),
        Expanded(
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                SafeCarousel(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Emergency",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllArticles(),
                            ),
                          );
                        },
                        child: Text("See More"),
                      ),
                    ],
                  ),
                ),
                Emergency(),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16.0, bottom: 10, top: 10),
                  child: Text(
                    "Explore LiveSafe",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                LiveSafe(),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LiveSafe extends StatelessWidget {
  const LiveSafe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          children: [
            PoliceStationCard(openMapFunc: openMap),
            HospitalCard(openMapFunc: openMap),
            PharmacyCard(openMapFunc: openMap),
            BusStationCard(openMapFunc: openMap)
          ]),
    );
  }

  static Future<void> openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';

    try {
      await launch(googleUrl);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Something went wrong! Call emergency numbers.");
    }
    // if (await canLaunch(googleUrl)) {
    //   await launch(googleUrl);
    // } else {
    //   throw 'Could not open the map.';
    // }
  }
}
