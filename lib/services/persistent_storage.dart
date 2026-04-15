import 'package:flutter_riverpod/flutter_riverpod.dart';

final persistentStorageProvider = Provider<PersistentStorage>((ref) {
  // This will be overridden in tests.
  return PersistentStorage();
});

class PersistentStorage {
  Future<List<String>?> readStringList(String key) async {
    // In a real app, this would read from SharedPreferences or other storage.
    return null;
  }

  Future<void> writeStringList(String key, List<String> value) async {
    // In a real app, this would write to SharedPreferences or other storage.
  }
}
