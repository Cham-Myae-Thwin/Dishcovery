// Fallback storage using SharedPreferences (mobile/desktop)
import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  const PersistentStorage();

  Future<List<String>?> readStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  Future<void> writeStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }
}

const persistentStorage = PersistentStorage();
