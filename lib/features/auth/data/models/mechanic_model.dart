import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';

class MechanicModel extends MechanicEntity {
  MechanicModel({
    required super.uid,
    required super.phoneNumber,
    super.name,
    super.shopName,
    super.email,
    super.profileImageUrl,
    super.specialization,
  });

  factory MechanicModel.fromMap(Map<String, dynamic> map) {
    return MechanicModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'],
      shopName: map['shopName'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
      specialization: map['specialization'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'shopName': shopName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'specialization': specialization,
    };
  }

  factory MechanicModel.fromEntity(MechanicEntity entity) {
    return MechanicModel(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,
      name: entity.name,
      shopName: entity.shopName,
      email: entity.email,
      profileImageUrl: entity.profileImageUrl,
      specialization: entity.specialization,
    );
  }
}
