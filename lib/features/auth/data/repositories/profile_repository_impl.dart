import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:road_resq/features/auth/domain/entities/user_entity.dart';
import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';

class ProfileRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(UserEntity user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'profileImage': user.profileImage,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveMechanic(MechanicEntity mechanic) async {
    await _firestore.collection('mechanics').doc(mechanic.uid).set({
      'uid': mechanic.uid,
      'name': mechanic.name,
      'shopName': mechanic.shopName,
      'email': mechanic.email,
      'phoneNumber': mechanic.phoneNumber,
      'profileImage': mechanic.profileImage,
      'specialization': mechanic.specialization,
      'role': 'mechanic',
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}