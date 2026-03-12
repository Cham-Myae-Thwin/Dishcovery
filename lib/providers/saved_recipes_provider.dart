import 'package:flutter_riverpod/flutter_riverpod.dart';

// Use conditional import for a small storage abstraction so web uses
// window.localStorage (more robust for hosting/service-worker scenarios)
import '../services/persistent_storage_stub.dart'
    if (dart.library.html) '../services/persistent_storage_web.dart';

const _savedKey = 'saved_recipe_ids';

class SavedRecipesNotifier extends StateNotifier<List<String>> {
  SavedRecipesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final stored = await persistentStorage.readStringList(_savedKey);
    state = stored ?? [];
  }

  Future<void> _persist() async {
    await persistentStorage.writeStringList(_savedKey, state);
  }

  bool isSaved(String id) => state.contains(id);

  Future<void> toggle(String id) async {
    final ids = List<String>.from(state);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = ids;
    await _persist();
  }

  /// Toggle and return whether the recipe is now saved (true) or removed (false).
  Future<bool> toggleAndGet(String id) async {
    final ids = List<String>.from(state);
    bool nowSaved;
    if (ids.contains(id)) {
      ids.remove(id);
      nowSaved = false;
    } else {
      ids.add(id);
      nowSaved = true;
    }
    state = ids;
    await _persist();
    return nowSaved;
  }
}

final savedRecipesProvider =
    StateNotifierProvider<SavedRecipesNotifier, List<String>>(
      (ref) => SavedRecipesNotifier(),
    );
