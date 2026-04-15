import 'package:dishcovery/services/persistent_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _savedKey = 'saved_recipe_ids';

class SavedRecipesNotifier extends StateNotifier<List<String>> {
  final PersistentStorage _storage;

  SavedRecipesNotifier(this._storage) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final stored = await _storage.readStringList(_savedKey);
    state = stored ?? [];
  }

  Future<void> _persist() async {
    await _storage.writeStringList(_savedKey, state);
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
  (ref) => SavedRecipesNotifier(ref.watch(persistentStorageProvider)),
);
