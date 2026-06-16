package dev.flutter.plugins.flutter_native_transliterate

import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * On-device script transliteration using the OS-native ICU engine
 * (android.icu.text.Transliterator, available since API 24). No network.
 */
class FlutterNativeTransliteratePlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_native_transliterate")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "transliterate" -> {
                val text = call.argument<String>("text") ?: ""
                val transform = call.argument<String>("transform") ?: ""
                if (text.isEmpty() || transform.isEmpty()) {
                    result.success(text)
                    return
                }
                // android.icu.text.Transliterator is only available API 24+.
                // On older devices return the input unchanged (treated as no-op).
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
                    result.success(text)
                    return
                }
                try {
                    val t = android.icu.text.Transliterator.getInstance(transform)
                    result.success(t.transliterate(text))
                } catch (e: Exception) {
                    // Unknown transform id / engine error -> original string.
                    result.success(text)
                }
            }
            "isSupported" -> result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
