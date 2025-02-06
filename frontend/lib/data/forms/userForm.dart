class UserForm {
  String? firstName;
  String? lastName;
  String email;
  String password;

  UserForm({
    this.firstName,
    this.lastName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }

  factory UserForm.fromJson(Map<String, dynamic> json) {
    return UserForm(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
    );
  }

}