class User {
  final String email;
  final String password;
  final String userType;

  User({
    required this.email,
    required this.password,
    required this.userType,
  });

  // Convert User to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'userType': userType,
    };
  }

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      password: json['password'] as String,
      userType: json['userType'] as String? ?? 'Resident',
    );
  }
}
