import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError();
});

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

// Add generic getter/setter methods here
}