class User {
  final String email;
  final String userType; // 'Resident', 'Garbage Collector', 'Admin'
  final String? fullName;
  final String? phoneNumber;
  final String? assignedZone;
  final String? password; // Temp for auth

  User({
    required this.email,
    required this.userType,
    this.fullName,
    this.phoneNumber,
    this.assignedZone,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userType': userType,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'assignedZone': assignedZone,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      userType: json['userType'] as String? ?? 'Resident',
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      assignedZone: json['assignedZone'] as String?,
      password: null,
    );
  }
}
