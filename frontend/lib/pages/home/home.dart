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
      final response = await http
          .get(Uri.parse('${Api.discussionsUrl}/user?userId=$userId'));
      if (response.statusCode == 200) {
        final discussions = jsonDecode(response.body) as List;
        setState(() {
          _discussions =
              discussions.map((e) => DiscussionModel.fromJson(e)).toList();
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
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (user != null) ...[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user['profilePicture'] ?? ''),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 3),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${user['firstName']} ${user['lastName']}',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Text(
                          user['email'],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.logout_rounded, color: Colors.white),
                      onPressed: () {
                        Provider.of<Auth>(context, listen: false).logout();
                      },
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _hasError
                        ? const Center(
                            child: Text('Error fetching discussions'))
                        : ListView.builder(
                            itemCount: _discussions.length,
                            itemBuilder: (context, index) {
                              final discussion = _discussions[index];
                              var isGroup = discussion.users!.length > 3;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: isGroup
                                      ? null
                                      : NetworkImage(discussion.users!
                                              .firstWhere(
                                                  (u) => u.id != user?['id'])
                                              .profilePicture ??
                                          ''),
                                ),
                                title: discussion.title != ''
                                    ? Text(discussion.title ?? '')
                                    : isGroup
                                        ? Text(discussion.users!.map((u) => '${u.firstName}').join(', '))
                                        : Text('${discussion.users!.firstWhere((u) => u.id != user?['id']).firstName} ${discussion.users!.firstWhere((u) => u.id != user?['id']).lastName}'),
                                subtitle: Text(discussion.lastMessage ?? ''),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(discussion: discussion),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            )
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
