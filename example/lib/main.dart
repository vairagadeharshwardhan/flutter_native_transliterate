import 'package:flutter/material.dart';
import 'package:flutter_native_transliterate/flutter_native_transliterate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController(text: 'Kothrud, Pune');
  String _lang = 'mr';
  String _out = '';
  bool _supported = false;

  static const _langs = ['mr', 'hi', 'kn', 'ta', 'te', 'ml', 'gu', 'pa', 'en'];

  @override
  void initState() {
    super.initState();
    FlutterNativeTransliterate.isSupported().then((v) {
      if (mounted) setState(() => _supported = v);
    });
    _run();
  }

  Future<void> _run() async {
    final out =
        await FlutterNativeTransliterate.forLanguage(_controller.text, _lang);
    if (mounted) setState(() => _out = out);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Native transliterate')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OS supported: $_supported'),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Text (Latin)'),
                onChanged: (_) => _run(),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _langs
                    .map((l) => ChoiceChip(
                          label: Text(l),
                          selected: _lang == l,
                          onSelected: (_) {
                            setState(() => _lang = l);
                            _run();
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(_out,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
