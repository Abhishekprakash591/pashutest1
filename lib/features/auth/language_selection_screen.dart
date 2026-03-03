import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pashucare_app/core/providers/locale_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  final List<Map<String, String>> languages = const [
    {'name': 'English', 'code': 'en'},
    {'name': 'हिंदी (Hindi)', 'code': 'hi'},
    {'name': 'मരാठी (Marathi)', 'code': 'mr'},
    {'name': 'ગુજરાતી (Gujarati)', 'code': 'gu'},
    {'name': 'ਪੰਜਾਬੀ (Punjabi)', 'code': 'pa'},
    {'name': 'தமிழ் (Tamil)', 'code': 'ta'},
    {'name': 'తెలుగు (Telugu)', 'code': 'te'},
    {'name': 'ಕನ್ನಡ (Kannada)', 'code': 'kn'},
    {'name': 'മലയാളം (Malayalam)', 'code': 'ml'},
  ];

  void _selectLanguage(BuildContext context, String code) {
    Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale(code));
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Choose your preferred language for PashuCare',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final lang = languages[index];
                return InkWell(
                  onTap: () => _selectLanguage(context, lang['code']!),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      lang['name']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'You can change this later in settings.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
