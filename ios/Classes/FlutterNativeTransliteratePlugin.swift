import Flutter
import UIKit

/// On-device script transliteration using the OS-native ICU engine
/// (CFStringTransform, available since iOS 9). No network.
public class FlutterNativeTransliteratePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_native_transliterate",
      binaryMessenger: registrar.messenger())
    let instance = FlutterNativeTransliteratePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "transliterate":
      let args = call.arguments as? [String: Any]
      let text = (args?["text"] as? String) ?? ""
      let transform = (args?["transform"] as? String) ?? ""
      if text.isEmpty || transform.isEmpty {
        result(text)
        return
      }
      // Apply an ICU transform id (e.g. "Latin-Devanagari") to the whole string.
      let mutable = NSMutableString(string: text)
      let ok = CFStringTransform(mutable as CFMutableString, nil, transform as CFString, false)
      result(ok ? (mutable as String) : text)
    case "isSupported":
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
