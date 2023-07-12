import 'dart:io';
import 'package:coastal/new.json.dart';
import 'package:coastal/screens/Emergency.dart';
import 'package:coastal/screens/audio.dart';
import 'package:coastal/screens/home.dart';
import 'package:coastal/screens/map.dart';
import 'package:coastal/screens/post_card.dart';
import 'package:coastal/screens/signUp.dart';
import 'package:coastal/screens/addPosts.dart';

import 'package:coastal/screens/slider.dart';
import 'package:coastal/screens/splash.dart';
import 'package:coastal/screens/torch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = '/mainscreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> headers = [
      "HomePage",
      "Gallery",
      "Add",
      "Notifications",
      "Profile",
    ];

    final List<Widget> widgetOptions = <Widget>[
      Home(),
      PostCard(),
      PostScreen(),      Maps(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black12,
                size: 25,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          headers[_selectedIndex],
          style: const TextStyle(
            fontFamily: 'medium',
            fontSize: 18,
            color: Color(0xff000000),
          ),
          textAlign: TextAlign.center,
          softWrap: false,
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PostCard()));
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>New()));

                },
              ),
              // Add more items as needed
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: widgetOptions,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.photo_library, size: 30),
          Icon(Icons.add_circle, size: 30),
          Icon(Icons.notifications, size: 30),
          Icon(Icons.person, size: 30),

        ],
        onTap: _onItemTapped,
        index: _selectedIndex,
      ),
    );
  }
}
