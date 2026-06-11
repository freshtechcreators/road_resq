import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/vehicle_repository.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(FirebaseFirestore.instance);
});

final vehiclesStreamProvider = StreamProvider<List<VehicleEntity>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  return ref.watch(vehicleRepositoryProvider).getVehicles(userId);
});