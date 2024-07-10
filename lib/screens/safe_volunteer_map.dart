import 'package:coastal/provider/mapu_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    ///  Provider.of<Profile>(context, listen: false).getProfile();
    Provider.of<HomeViewModel>(context, listen: false).futureToRun();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.isBusy
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: viewModel.onMapCreated,
                  initialCameraPosition: viewModel.kInitialPosition,
                  markers: viewModel.markers,
                );
        },
      ),
    );
  }
}
