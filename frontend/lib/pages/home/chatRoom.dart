import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/DiscussionModel.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<MessageModel> _messages = [];
  late IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    _socket = IO.io(Api.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.on('receiveMessage', (data) {
      final message = MessageModel.fromJson(data);
      setState(() {
        _messages.add(message);
      });
      scrollToBottom();
    });

    _socket.connect();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final response = await http.get(
        Uri.parse('${Api.messagesUrl}?discussionId=${widget.discussion.id}'));
    if (response.statusCode == 200) {
      final List<dynamic> messageList = jsonDecode(response.body);
      setState(() {
        _messages.addAll(messageList.map((e) => MessageModel.fromJson(e)).toList());
      });
      scrollToBottom();
    }
  }

  @override
  void dispose() {
    _socket.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final user = Provider.of<Auth>(context, listen: false).user;
    if (_messageController.text.isEmpty) return;

    final message = {
      'discussionId': widget.discussion.id,
      'content': _messageController.text,
      'sender': user?['_id'],
    };

    _socket.emit('sendMessage', message);
    _messageController.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
            ? Text(widget.discussion.users!
            .map((u) => '${u.firstName}')
            .join(', '))
            : Text(
            '${widget.discussion.users!.firstWhere((u) => u.id != user?['_id']).firstName} ${widget.discussion.users!.firstWhere((u) => u.id != user?['id']).lastName}'),
      ),
      body: Container(
        constraints: BoxConstraints(minHeight: double.infinity),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false, scrollbars: false),
                child: ListView(
                  controller: _scrollController,
                  children: _messages.map((message) => _buildMessageItem(message)).toList(),
                ),
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
                      onSubmitted: (value) => _sendMessage(),
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

  Widget _buildMessageItem(MessageModel message) {
    final user = Provider.of<Auth>(context).user;
    final isSender = message.sender?.id == user?['_id'];
    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: alignment,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: isSender ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                message.content ?? '',
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            alignment: alignment,
            child: Text(
              message.date != null
                  ? '${message.date!.hour}:${message.date!.minute}'
                  : '',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}