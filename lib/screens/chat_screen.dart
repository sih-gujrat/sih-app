import 'package:coastal/screens/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _messages = <Message>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff618ee3),
      appBar: AppBar(
        backgroundColor: const Color(0xff618ee3),
        title: const Text(
          'Disaster Helper',
          style: TextStyle(fontSize: 20, color: Colors.white),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Information or settings page
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: FlutterGemmaPlugin.instance.isInitialized,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting && snapshot.data == true) {
                return ChatListWidget(
                  gemmaHandler: (message) {
                    setState(() {
                      _messages.add(message);
                    });
                  },
                  humanHandler: (text) {
                    setState(() {
                      _messages.add(Message(text: text, isUser: true));
                    });
                  },
                  messages: _messages,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),

    );
  }
}
