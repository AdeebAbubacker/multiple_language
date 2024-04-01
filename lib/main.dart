import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() {
  runApp(const MyApp());
}

mixin AppLocale {
  static const String title = 'title';
  static const String thisIs = 'ഈ ഭാഷ നിലവിൽ ലഭ്യമല്ല';

  static const Map<String, dynamic> EN = {
    title: 'Localization',
    thisIs: 'The Apple was eaten by John',
  };

  static const Map<String, dynamic> HI = {
    title: 'Localization',
    thisIs: 'सेब जॉन ने खाया',
  };

  static const Map<String, dynamic> ML = {
    title: 'Localization',
   // thisIs: 'ആപ്പിൾ കഴിച്ചത് ജോൺ ആണ്',
  };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'ml',
          AppLocale.ML,
          countryCode: 'IN',
          fontFamily: 'Font ML',
        ),
        const MapLocale(
          'hi',
          AppLocale.HI,
          countryCode: 'IN',
          fontFamily: 'Font HI',
        ),
      ],
      initLanguageCode: 'en',
    );

    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      home: const SettingsScreen(),
      theme: ThemeData(fontFamily: _localization.fontFamily),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en'; // Default language
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Language')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _localization.translate(newValue);
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                }
              },
              items: <String>[
                'en',
                'ml',
                'hi',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),


            const SizedBox(height: 16.0),
            ItemWidget(
              title: 'Current Language',
              content: _localization.getLanguageName(),
            ),
            ItemWidget(
              title: 'Font Family',
              content: _localization.fontFamily,
            ),
            ItemWidget(
              title: 'Locale Identifier',
              content: _localization.currentLocale.localeIdentifier,
            ),
            ItemWidget(
              title: 'Context Format String',
              content: context.formatString(
                AppLocale.thisIs,
                [AppLocale.title],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.title,
    required this.content,
  });

  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title ?? '')),
          const Text(' : '),
          Expanded(child: Text(content ?? '')),
        ],
      ),
    );
  }
}

// mutiple language
