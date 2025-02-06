import 'package:flutterchat/data/models/UserModel.dart';

class DiscussionModel {
  String? _chatRoomId;
  List<UserModel>? _users;
  String? _lastMessage;
  DateTime? _lastMessageTime;

  DiscussionModel({
    String? chatRoomId,
    List<UserModel>? users,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    _chatRoomId = chatRoomId;
    _users = users;
    _lastMessage = lastMessage;
    _lastMessageTime = lastMessageTime;
  }

  String? get chatRoomId => _chatRoomId;
  List<UserModel>? get users => _users;
  String? get lastMessage => _lastMessage;
  DateTime? get lastMessageTime => _lastMessageTime;

  DiscussionModel.fromJson(Map<String, dynamic> json) {
    _chatRoomId = json['chatRoomId'];
    if (json['users'] != null) {
      _users = [];
      json['users'].forEach((v) {
        _users!.add(UserModel.fromJson(v));
      });
    }
    _lastMessage = json['lastMessage'];
    _lastMessageTime = DateTime.parse(json['lastMessageTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatRoomId'] = _chatRoomId;
    if (_users != null) {
      data['users'] = _users!.map((v) => v.toJson()).toList();
    }
    data['lastMessage'] = _lastMessage;
    data['lastMessageTime'] = _lastMessageTime!.toIso8601String();
    return data;
  }
}