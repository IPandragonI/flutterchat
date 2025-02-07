import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;

  const ChatRoom({super.key, required this.chatRoomId});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Container(
        constraints: BoxConstraints(minHeight: double.infinity),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(64, 110, 255, 1),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  const Text('Messages'),
                ],
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Type a message',
              ),
            ),
          ],
        ),
      ),
    );
  }
}