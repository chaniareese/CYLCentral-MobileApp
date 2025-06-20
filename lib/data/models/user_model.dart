// User model representing a user profile and role in the app.
class User {
  // User fields (most are nullable for flexibility with backend data)
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? contactNumber;
  final String? birthdate;
  final String? employmentStatus;
  final String? company;
  final String? region;
  final String? province;
  final String? role;
  final String? createdAt;
  final String? profilePicture;

  // Constructor for User
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.contactNumber,
    this.birthdate,
    this.employmentStatus,
    this.company,
    this.region,
    this.province,
    this.role,
    this.createdAt,
    this.profilePicture, // Added profile_picture parameter
  });

  // Factory: Create a User from a Map (e.g., from JSON)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      contactNumber: map['contact_number'],
      birthdate: map['birthdate'],
      employmentStatus: map['employment_status'],
      company: map['company'],
      region: map['region'],
      province: map['province'],
      role: map['role'],
      createdAt: map['created_at'],
      profilePicture: map['profile_picture'],
    );
  }

  // Convert User to a Map (e.g., for sending to backend)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'contact_number': contactNumber,
      'birthdate': birthdate,
      'employment_status': employmentStatus,
      'company': company,
      'region': region,
      'province': province,
      'role': role,
      'created_at': createdAt,
      'profile_picture': profilePicture,
    };
  }

  // Role helpers for easy role-based UI logic
  bool get isAdmin {
    final r = role?.toLowerCase().replaceAll(' ', '');
    return r == 'admin' || r == 'programdirector' || r == 'executivecommittee';
  }

  bool get isExecCommittee =>
      role?.toLowerCase().replaceAll(' ', '') == 'executivecommittee';
  bool get isProgramDirector =>
      role?.toLowerCase().replaceAll(' ', '') == 'programdirector';
  bool get isMember => role?.toLowerCase().replaceAll(' ', '') == 'member';
  bool get isParticipant =>
      role?.toLowerCase().replaceAll(' ', '') == 'participant';
}
