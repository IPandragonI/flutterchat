class UserModel {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _profilePicture;

  UserModel({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _profilePicture = profilePicture;
  }

  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get profilePicture => _profilePicture;

  UserModel.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'profilePicture': _profilePicture,
    };
  }
}

