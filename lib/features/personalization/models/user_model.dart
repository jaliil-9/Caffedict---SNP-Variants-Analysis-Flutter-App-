class UserModel {
  final String id;
  String firstname;
  String lastname;
  final String email;
  String profilePicture;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.profilePicture,
  });

  // Get full name
  String get fullName => '$firstname $lastname';

  // Split full name into parts
  static List<String> nameParts(String fullName) => fullName.split(" ");

  // Generate a username from full name
  static String generateUserName(String fullName) {
    final nameParts = fullName.split(" ");
    final firstname = nameParts[0].toLowerCase();
    final lastname = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";
    return "cwt_$firstname$lastname";
  }

  // Empty user model
  static UserModel empty() => UserModel(
        id: '',
        firstname: '',
        lastname: '',
        email: '',
        profilePicture: '',
      );

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }
}
