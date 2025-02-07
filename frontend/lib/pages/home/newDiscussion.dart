import 'package:flutter/material.dart';
import 'package:flutterchat/data/models/UserModel.dart';
import 'package:flutterchat/utils/api.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../providers/auth.dart';
import 'chatRoom.dart';

class NewDiscussion extends StatefulWidget {
  const NewDiscussion({super.key});

  @override
  _NewDiscussionState createState() => _NewDiscussionState();
}

class _NewDiscussionState extends State<NewDiscussion> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  final List<String> _selectedIds = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<Auth>(context, listen: false).user?['id'];
    if(userId != null) {
      _selectedIds.add(userId);
    }
    _fetchUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    try {
      final email = Provider.of<Auth>(context, listen: false).user?['email'];
      final users = await fetchUsers(email);
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedIds.contains(userId)) {
        _selectedIds.remove(userId);
      } else {
        _selectedIds.add(userId);
      }
    });
  }

  Future<void> _createOrGetDiscussion() async {
    try {
      final response = await http.post(
        Uri.parse(Api.discussionsUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'usersIds': _selectedIds}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final discussion = json.decode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoom(discussion: discussion),
          ),
        );
      } else {
        throw Exception('Failed to create or get discussion');
      }
    } catch (e) {
      throw Exception('Failed to call api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle discussion'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('À : '),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                ? const Center(child: Text('Error fetching users'))
                : _filteredUsers.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                final isSelected = _selectedIds.contains(user.id);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePicture ?? ''),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email ?? ''),
                  trailing: GestureDetector(
                    onTap: () => _toggleSelection(user.id!),
                    child: CircleAvatar(
                      backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                      radius: 10,
                    ),
                  ),
                  onTap: () {
                    _toggleSelection(user.id!);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIds.length > 1
          ? FloatingActionButton(
        onPressed: _createOrGetDiscussion,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.chat_rounded),
      )
          : null,
    );
  }

  Future<List<UserModel>> fetchUsers(String email) async {
    try {
      final response = await http.get(Uri.parse('${Api.usersUrl}/without?email=$email'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      throw Exception('Failed to fetch users');
    }
  }
}