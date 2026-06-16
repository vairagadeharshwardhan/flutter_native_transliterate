import 'dart:async';

import 'package:flutter/services.dart';

/// On-device script transliteration via the OS-native ICU engine —
/// Android `android.icu.text.Transliterator` (API 24+), iOS `CFStringTransform`.
/// No network, no API key, no cost. Returns the input unchanged on unsupported
/// OS / unknown transform / any failure (always safe to call).
///
/// NOTE: this is phonetic *script conversion*, not translation — it renders the
/// letters in the target script (e.g. "Kothrud" -> "कोथरुड"), which is
/// approximate spelling, not a curated localized name.
class FlutterNativeTransliterate {
  FlutterNativeTransliterate._();

  static const MethodChannel _channel =
      MethodChannel('flutter_native_transliterate');

  /// Transliterates [text] with an ICU transform id (e.g. `'Latin-Devanagari'`,
  /// `'Latin-Tamil'`, `'Latin-Kannada'`). Returns [text] unchanged on failure.
  static Future<String> transliterate(String text, String transformId) async {
    if (text.isEmpty || transformId.isEmpty) return text;
    try {
      final r = await _channel.invokeMethod<String>('transliterate', {
        'text': text,
        'transform': transformId,
      });
      return (r == null || r.isEmpty) ? text : r;
    } on PlatformException {
      return text;
    } on MissingPluginException {
      return text;
    }
  }

  /// Convenience: transliterate [text] into the script of an app language code.
  /// Returns [text] unchanged for `'en'` and any unmapped language.
  static Future<String> forLanguage(String text, String languageCode) {
    final id = transformForLanguage(languageCode);
    if (id == null) return Future<String>.value(text);
    return transliterate(text, id);
  }

  /// Maps an app language code to its ICU Latin->script transform id, or null
  /// when no transliteration applies (English / unknown).
  static String? transformForLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi':
      case 'mr':
        return 'Latin-Devanagari';
      case 'kn':
        return 'Latin-Kannada';
      case 'ta':
        return 'Latin-Tamil';
      case 'te':
        return 'Latin-Telugu';
      case 'ml':
        return 'Latin-Malayalam';
      case 'gu':
        return 'Latin-Gujarati';
      case 'pa':
        return 'Latin-Gurmukhi';
      default:
        return null; // en / unsupported -> no-op
    }
  }

  /// Whether the OS supports native transliteration (Android API 24+; iOS true).
  static Future<bool> isSupported() async {
    try {
      final r = await _channel.invokeMethod<bool>('isSupported');
      return r ?? false;
    } catch (_) {
      return false;
    }
  }
}
