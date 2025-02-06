class UserModel {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _profilePicture;

  UserModel({
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _profilePicture = profilePicture;
  }

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get profilePicture => _profilePicture;

  UserModel.fromJson(Map<String, dynamic> json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'profilePicture': _profilePicture,
    };
  }
}

