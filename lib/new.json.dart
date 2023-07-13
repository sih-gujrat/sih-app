import 'dart:async';

import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:just_audio/just_audio.dart';

class New extends StatefulWidget {
  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  int _currentIndex = 0;
  late PageController _pageController;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool isTorchEnabled = false;
  Timer? blinkTimer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setAsset('assets/buzzers.mp3');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onBottomNavBarTap(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _toggleAudioPlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      supportedLocales: const [Locale('en', '')],

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torch & Audio Player'),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            TorchController(

            ),
            AudioPlayerPage(
              isPlaying: _isPlaying,
              toggleAudioPlayback: _toggleAudioPlayback,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavBarTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.flashlight_on),
              label: 'Torch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.audiotrack),
              label: 'Audio Player',
            ),
          ],
        ),
      ),
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

class AudioPlayerPage extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback toggleAudioPlayback;

  const AudioPlayerPage({
    required this.isPlaying,
    required this.toggleAudioPlayback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: toggleAudioPlayback,
        child: Text(isPlaying ? 'Pause' : 'Play'),
      ),
    );
  }
}
