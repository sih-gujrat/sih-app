import 'package:coastal/provider/mapu_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
          if (viewModel.shouldShowPrompt) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showResourcesDialog(context, viewModel);
            });
          }
          return viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: viewModel.onMapCreated,
                  initialCameraPosition: viewModel.kInitialPosition,
                  markers: viewModel.markers,
                );
        },
      ),
    );
  }

  void _showResourcesDialog(BuildContext context, HomeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Resources Available"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text("Please enter the amount of resources you need:"),
                TextFormField(
                  controller: viewModel.waterController,
                  decoration: const InputDecoration(
                    labelText: 'Water (in liters)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: viewModel.clothingController,
                  decoration: const InputDecoration(
                    labelText: 'Clothing (in items)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: viewModel.foodController,
                  decoration: const InputDecoration(
                    labelText: 'Food (in units)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: viewModel.medicalController,
                  decoration: const InputDecoration(
                    labelText: 'Medical Supplies (in units)',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Request"),
              onPressed: () async {
                String city = await viewModel.getCityFromLocation();

                print(
                    "Requested: ${viewModel.waterController.text} liters of water");
                print(
                    "Requested: ${viewModel.clothingController.text} clothing items");
                print("Requested: ${viewModel.foodController.text} food units");
                print(
                    "Requested: ${viewModel.medicalController.text} medical units");
                var userid = viewModel.userId;
                var data = {
                  "waterSuppliesLiters": viewModel.waterController.text,
                  "clothingSuppliesItems": viewModel.clothingController.text,
                  "foodSuppliesUnits": viewModel.foodController.text,
                  "medicalSuppliesUnits": viewModel.medicalController.text,
                  "location_of_request": city
                };
                print(city);
                await viewModel.sendResourceRequest(
                    "https://mustang-helpful-lively.ngrok-free.app/api/admin/updateUserResource/${userid}",
                    data);
                 Navigator.of(context).pop();
                await Fluttertoast.showToast(
                    msg: "Resources requested successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );

              },
            ),
          ],
        );
      },
    );
  }
}
