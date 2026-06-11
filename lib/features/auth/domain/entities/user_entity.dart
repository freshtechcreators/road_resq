class UserEntity {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final String role;
  final DateTime? createdAt;

  UserEntity({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profileImageUrl,
    this.role = 'user',
    this.createdAt,
  });

  UserEntity copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? email,
    String? profileImageUrl,
    String? role,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}