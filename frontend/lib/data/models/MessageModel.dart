import 'package:flutterchat/data/models/UserModel.dart';

class MessageModel {
  String? _id;
  String? _discussionId;
  String? _content;
  UserModel? _sender;
  DateTime? _date;
  List<UserModel>? _seenBy;

  MessageModel({
    String? id,
    String? discussionId,
    String? content,
    UserModel? sender,
    DateTime? date,
    List<UserModel>? seenBy,
  }) {
    _id = id;
    _discussionId = discussionId;
    _content = content;
    _sender = sender;
    _date = date;
    _seenBy = seenBy;
  }

  String? get id => _id;
  String? get discussionId => _discussionId;
  String? get content => _content;
  UserModel? get sender => _sender;
  DateTime? get date => _date;
  List<UserModel>? get seenBy => _seenBy;

  MessageModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _discussionId = json['discussionId'];
    _content = json['content'];
    _sender = UserModel.fromJson(json['sender']);
    _date = DateTime.parse(json['date']);
    if (json['seenBy'] != null) {
      _seenBy = [];
      json['seenBy'].forEach((v) {
        _seenBy!.add(UserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'discussionId': _discussionId,
      'content': _content,
      'sender': _sender?.toJson(),
      'date': _date?.toIso8601String(),
      'seenBy': _seenBy?.map((e) => e.toJson()).toList(),
    };
  }
}