import 'package:flutterchat/data/models/UserModel.dart';

class DiscussionModel {
  String? _id;
  String? _title;
  List<UserModel>? _users;
  String? _lastMessage;
  DateTime? _lastMessageDate;

  DiscussionModel({
    String? id,
    String? title,
    List<UserModel>? users,
    String? lastMessage,
    DateTime? lastMessageDate,
  }) {
    _id = id;
    _title = title;
    _users = users;
    _lastMessage = lastMessage;
    _lastMessageDate = lastMessageDate;
  }

  String? get id => _id;
  String? get title => _title;
  List<UserModel>? get users => _users;
  String? get lastMessage => _lastMessage;
  DateTime? get lastMessageDate => _lastMessageDate;

  DiscussionModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    if (json['users'] != null) {
      _users = (json['users'] as List).map((i) => UserModel.fromJson(i)).toList();
    }
    _lastMessage = json['lastMessage'];
    _lastMessageDate = json['lastMessageDate'] != null ? DateTime.parse(json['lastMessageDate']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    if (_users != null) {
      data['users'] = _users!.map((v) => v.toJson()).toList();
    }
    data['lastMessage'] = _lastMessage;
    data['lastMessageDate'] = _lastMessageDate!.toIso8601String();
    return data;
  }
}