class UserEntity {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profileImageUrl;

  UserEntity({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profileImageUrl,
  });

  UserEntity copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? email,
    String? profileImageUrl,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
