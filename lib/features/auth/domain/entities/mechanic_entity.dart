class MechanicEntity {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? shopName;
  final String? email;
  final String? profileImage;
  final String? specialization;
  final List<String>? services;
  final String? experience;
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
    this.profileImage,
    this.specialization,
    this.services,
    this.experience,
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
    String? profileImage,
    String? specialization,
    List<String>? services,
    String? experience,
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
      profileImage: profileImage ?? this.profileImage,
      specialization: specialization ?? this.specialization,
      services: services ?? this.services,
      experience: experience ?? this.experience,
      isApproved: isApproved ?? this.isApproved,
      isOnline: isOnline ?? this.isOnline,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
