import 'package:road_resq/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.phoneNumber,
    super.name,
    super.email,
    super.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,
      name: entity.name,
      email: entity.email,
      profileImageUrl: entity.profileImageUrl,
    );
  }
}
