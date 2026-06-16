# flutter_native_transliterate

On-device **script transliteration** using the OS-native ICU engine — no network, no API key, no cost.

- **Android**: `android.icu.text.Transliterator` (API 24+)
- **iOS**: `CFStringTransform` (iOS 9+)

Transliteration is phonetic **script conversion**, not translation: it renders letters in a target script (e.g. `Kothrud` → `कोथरुड`). It is approximate spelling — not a curated localized name. Returns the input unchanged on unsupported OS / unknown transform / any failure, so it is always safe to call.

## Usage

```dart
import 'package:flutter_native_transliterate/flutter_native_transliterate.dart';

// By ICU transform id:
final hi = await FlutterNativeTransliterate.transliterate('Kothrud', 'Latin-Devanagari');

// Or by app language code (en/unknown -> returned unchanged):
final s = await FlutterNativeTransliterate.forLanguage('Kothrud', 'mr');
```

### Language → transform mapping (`forLanguage`)
`hi`/`mr` → `Latin-Devanagari`, `kn` → `Latin-Kannada`, `ta` → `Latin-Tamil`,
`te` → `Latin-Telugu`, `ml` → `Latin-Malayalam`, `gu` → `Latin-Gujarati`,
`pa` → `Latin-Gurmukhi`. Any other code (incl. `en`) is a no-op.

Any ICU transform id supported by the platform works via `transliterate(text, id)`.
