/// Hive deserializes nested maps/lists as `Map<dynamic, dynamic>` /
/// `List<dynamic>` regardless of how they were written — a shallow
/// `Map<String, dynamic>.from(raw)` only fixes the top level. Generated
/// `fromJson` code (freezed/json_serializable) casts nested maps straight
/// to `Map<String, dynamic>` (e.g. each entry of a `List<Genre>`), which
/// throws on Hive's native map type. This walks the whole structure and
/// coerces every nested map/list so `fromJson` sees exactly the shape it
/// expects, as if it had come straight from `jsonDecode`.
Map<String, dynamic> deepJsonMap(Map<dynamic, dynamic> raw) =>
    raw.map((key, value) => MapEntry(key as String, _deepJsonValue(value)));

dynamic _deepJsonValue(dynamic value) {
  if (value is Map) return deepJsonMap(Map<dynamic, dynamic>.from(value));
  if (value is List) return value.map(_deepJsonValue).toList();
  return value;
}
