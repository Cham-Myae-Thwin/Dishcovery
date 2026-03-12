// Web storage implementation using window.localStorage
// This file is only imported on web via conditional import.
import 'dart:html' as html;

class PersistentStorage {
  const PersistentStorage();

  Future<List<String>?> readStringList(String key) async {
    try {
      final raw = html.window.localStorage[key];
      if (raw == null) return null;
      // Stored as JSON-encoded list
      // A very small, safe parser for a JSON array of strings
      final trimmed = raw.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        // crude split, assumes no nested commas in strings
        final inner = trimmed.substring(1, trimmed.length - 1).trim();
        if (inner.isEmpty) return <String>[];
        final parts = inner.split(',').map((s) {
          var v = s.trim();
          if (v.startsWith('"') && v.endsWith('"')) {
            v = v.substring(1, v.length - 1);
          }
          return v.replaceAll('\\"', '"');
        }).toList();
        return parts;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeStringList(String key, List<String> value) async {
    try {
      final encoded =
          '[${value.map((s) => '"${s.replaceAll('"', '\\"')}"').join(',')}]';
      html.window.localStorage[key] = encoded;
    } catch (_) {}
  }
}

const persistentStorage = PersistentStorage();
