import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/tracking_repository_impl.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../domain/usecases/get_mechanic_location_usecase.dart';
import '../../domain/usecases/get_route_points_usecase.dart';
import '../../domain/usecases/update_location_usecase.dart';
import '../../domain/entities/live_location_entity.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepositoryImpl(FirebaseFirestore.instance);
});

final updateLocationUseCaseProvider = Provider<UpdateLocationUseCase>((ref) {
  return UpdateLocationUseCase(ref.watch(trackingRepositoryProvider));
});

final getMechanicLocationUseCaseProvider = Provider<GetMechanicLocationUseCase>((ref) {
  return GetMechanicLocationUseCase(ref.watch(trackingRepositoryProvider));
});

final getRoutePointsUseCaseProvider = Provider<GetRoutePointsUseCase>((ref) {
  return GetRoutePointsUseCase(ref.watch(trackingRepositoryProvider));
});

final mechanicLocationStreamProvider = StreamProvider.family<LiveLocationEntity, String>((ref, mechanicId) {
  return ref.watch(getMechanicLocationUseCaseProvider).call(mechanicId);
});
