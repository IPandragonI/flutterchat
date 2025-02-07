class MessageModel {
  String? _id;
  String? _chatRoomId;
  String? _content;
  String? _senderId;

  MessageModel({
    String? id,
    String? chatRoomId,
    String? content,
    String? senderId,
  }) {
    _id = id;
    _chatRoomId = chatRoomId;
    _content = content;
    _senderId = senderId;
  }

  String? get id => _id;
  String? get chatRoomId => _chatRoomId;
  String? get content => _content;
  String? get senderId => _senderId;

  MessageModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _chatRoomId = json['chatRoomId'];
    _content = json['content'];
    _senderId = json['senderId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'chatRoomId': _chatRoomId,
      'content': _content,
      'senderId': _senderId,
    };
  }
}