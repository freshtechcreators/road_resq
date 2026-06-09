import 'package:road_resq/features/auth/domain/entities/user_entity.dart';
import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';
import 'package:road_resq/features/auth/domain/repositories/auth_repository.dart';

class SaveProfileUseCase {
  final AuthRepository repository;

  SaveProfileUseCase(this.repository);

  Future<void> saveUser(UserEntity user) {
    return repository.saveUserProfile(user);
  }

  Future<void> saveMechanic(MechanicEntity mechanic) {
    return repository.saveMechanicProfile(mechanic);
  }
}
