## 0.1.0

* Initial release. On-device ICU script transliteration via platform channels.
* Android: `android.icu.text.Transliterator` (API 24+; runtime-guarded, no-op below 24).
* iOS: `CFStringTransform` (iOS 9+).
* API: `transliterate(text, transformId)`, `forLanguage(text, languageCode)`,
  `transformForLanguage(languageCode)`, `isSupported()`.
* Always safe: returns the input unchanged on unsupported OS / unknown transform / failure.
