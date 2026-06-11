class MechanicEntity {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? shopName;
  final String? email;
  final String? profileImageUrl;
  final String? specialization;

  final bool isApproved;
  final bool isOnline;
  final String role;
  final DateTime? createdAt;

  MechanicEntity({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.shopName,
    this.email,
    this.profileImageUrl,
    this.specialization,
    this.isApproved = false,
    this.isOnline = false,
    this.role = 'mechanic',
    this.createdAt,
  });

  MechanicEntity copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? shopName,
    String? email,
    String? profileImageUrl,
    String? specialization,
    bool? isApproved,
    bool? isOnline,
    String? role,
    DateTime? createdAt,
  }) {
    return MechanicEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      shopName: shopName ?? this.shopName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      specialization: specialization ?? this.specialization,
      isApproved: isApproved ?? this.isApproved,
      isOnline: isOnline ?? this.isOnline,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}