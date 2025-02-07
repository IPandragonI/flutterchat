import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../providers/auth.dart';
import 'newDiscussion.dart';
import 'chatRoom.dart';
import '../../utils/api.dart';
import '../../data/models/DiscussionModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DiscussionModel> _discussions = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchDiscussions();
  }

  Future<void> _fetchDiscussions() async {
    try {
      final userId = Provider.of<Auth>(context, listen: false).user?['id'];
      final response = await http.get(Uri.parse('${Api.discussionsUrl}/user?userId=$userId'));
      if (response.statusCode == 200) {
        final discussions = jsonDecode(response.body) as List;
        setState(() {
          _discussions = discussions.map((e) => DiscussionModel.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch discussions');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).user;

    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: double.infinity),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(64, 110, 255, 1),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              color: Color.fromRGBO(64, 110, 255, 1),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user != null) ...[
                      Text(
                        user['firstName'],
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(width: 10),
                      Text(
                        user['lastName'],
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasError
                  ? const Center(child: Text('Error fetching discussions'))
                  : ListView.builder(
                itemCount: _discussions.length,
                itemBuilder: (context, index) {
                  final discussion = _discussions[index];
                  return ListTile(
                    title: Text(discussion.id??'Default title'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(chatRoomId: discussion.id ?? ''),                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewDiscussion()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}