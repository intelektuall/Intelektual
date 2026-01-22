// lib/utils/localization_helper.dart

String localizedValue(
  Map<String, dynamic>? json,
  String locale, {
  String fallback = 'en',
}) {
  if (json == null || json.isEmpty) return '';
  return json[locale] ?? json[fallback] ?? '';
}
