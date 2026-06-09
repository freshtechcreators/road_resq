class MechanicEntity {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? shopName;
  final String? email;
  final String? profileImageUrl;
  final String? specialization;

  MechanicEntity({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.shopName,
    this.email,
    this.profileImageUrl,
    this.specialization,
  });

  MechanicEntity copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? shopName,
    String? email,
    String? profileImageUrl,
    String? specialization,
  }) {
    return MechanicEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      shopName: shopName ?? this.shopName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      specialization: specialization ?? this.specialization,
    );
  }
}
