import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/mechanic_entity.dart';

class MechanicModel extends MechanicEntity {
  MechanicModel({
    required super.uid,
    required super.phoneNumber,
    super.name,
    super.shopName,
    super.email,
    super.profileImage,
    super.services,
    super.experience,
    super.isApproved,
    super.isOnline,
    super.role,
    super.createdAt,
  });

  factory MechanicModel.fromMap(Map<String, dynamic> map) {
    return MechanicModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'],
      shopName: map['shopName'],
      email: map['email'],
      profileImage: map['profileImage'],
      services: map['services'] != null ? List<String>.from(map['services']) : null,
      experience: map['experience'],
      isApproved: map['isApproved'] ?? false,
      isOnline: map['isOnline'] ?? false,
      role: map['role'] ?? 'mechanic',
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'shopName': shopName,
      'email': email,
      'profileImage': profileImage,
      'services': services,
      'experience': experience,
      'isApproved': isApproved,
      'isOnline': isOnline,
      'role': role,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory MechanicModel.fromEntity(MechanicEntity entity) {
    return MechanicModel(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,
      name: entity.name,
      shopName: entity.shopName,
      email: entity.email,
      profileImage: entity.profileImage,
      services: entity.services,
      experience: entity.experience,
      isApproved: entity.isApproved,
      isOnline: entity.isOnline,
      role: entity.role,
      createdAt: entity.createdAt,
    );
  }
}
