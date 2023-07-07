import 'package:coastal/screens/Emergencies/AmbulanceEmergency.dart';
import 'package:coastal/screens/Emergencies/ArmyEmergency.dart';
import 'package:coastal/screens/Emergencies/FirebrigadeEmergency.dart';
import 'package:coastal/screens/Emergencies/PoliceEmergency.dart';
import 'package:flutter/material.dart';


class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          AmbulanceEmergency(),
          FireEmergency(),
          ArmyEmergency()
        ],
      ),
    );
  }
}
