import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';



class TorchApp extends StatefulWidget {
  @override
  _TorchAppState createState() => _TorchAppState();
}

class _TorchAppState extends State<TorchApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [Locale('en', '')],

      home: TorchController(),
    );
  }
}

class TorchController extends StatefulWidget {
  @override
  _TorchControllerState createState() => _TorchControllerState();
}

class _TorchControllerState extends State<TorchController> {
  bool isTorchEnabled = false;
  Timer? blinkTimer;

  @override
  void initState() {
    super.initState();
    startBlinking();
  }

  @override
  void dispose() {
    stopBlinking();
    super.dispose();
  }

  void startBlinking() {
    stopBlinking();

    const blinkInterval = Duration(milliseconds: 10);

    setState(() {
      toggleTorch();
    });

    blinkTimer = Timer.periodic(blinkInterval, (_) {
      setState(() {
        toggleTorch();
      });
    });
  }

  void stopBlinking() {
    blinkTimer?.cancel();
    blinkTimer = null;
  }

  Future<void> toggleTorch() async {
    try {
      if (isTorchEnabled) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() {
        isTorchEnabled = !isTorchEnabled;
      });
    } on Exception catch (e) {
      _showMessage('Could not toggle torch: $e', context);
    }
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('torch_light example app'),
      ),
      body: Center(
        child: isTorchEnabled
            ? const Icon(Icons.flash_on, size: 150)
            : const Icon(Icons.flash_off, size: 150),
      ),
    );
  }
}
