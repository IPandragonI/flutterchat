import 'package:flutter/material.dart';
import 'package:flutterchat/data/models/DiscussionModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/MessageModel.dart';
import '../../providers/auth.dart';
import '../../utils/api.dart';

class ChatRoom extends StatefulWidget {
  final DiscussionModel discussion;

  const ChatRoom({super.key, required this.discussion});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<MessageModel> _messages = [];
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse('${Api.messagesUrl}?discussionId=${widget.discussion.id}'));
      if (response.statusCode == 200) {
        final messages = jsonDecode(response.body) as List;
        setState(() {
          if (messages.isNotEmpty) {
            _messages = messages.map((e) => MessageModel.fromJson(e)).toList();
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch messages');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _sendMessage() async {
    final user = Provider.of<Auth>(context, listen: false).user;
    if (_messageController.text.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse(Api.messagesUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'discussionId': widget.discussion.id,
          'content': _messageController.text,
          'sender': user?['id'],
        }),
      );

      if (response.statusCode == 201) {
        _messageController.clear();
        _fetchMessages();
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user;
    var isGroup = widget.discussion.users!.length > 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.phone_rounded),
            onPressed: () {},
          ),
        ],
        title: widget.discussion.title != ''
            ? Text(widget.discussion.title ?? '')
            : isGroup
            ? Text(widget.discussion.users!.map((u) => '${u.firstName}').join(', '))
            : Text('${widget.discussion.users!.firstWhere((u) => u.id != user?['id']).firstName} ${widget.discussion.users!.firstWhere((u) => u.id != user?['id']).lastName}'),
      ),
      body: Container(
        constraints: BoxConstraints(minHeight: double.infinity),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  const Text('Messages'),
                ],
              ),
            ),
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Écrire un message',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}