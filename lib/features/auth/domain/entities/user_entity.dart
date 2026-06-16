class UserEntity {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profileImage;
  final String role;
  final DateTime? createdAt;

  UserEntity({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profileImage,
    this.role = 'user',
    this.createdAt,
  });

  UserEntity copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? email,
    String? profileImage,
    String? role,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}