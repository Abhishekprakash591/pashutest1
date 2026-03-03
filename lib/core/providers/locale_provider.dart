import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  void setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
    notifyListeners();
  }

  // Simple Translation System
  static final Map<String, Map<String, String>> _translations = {
    'en': {
      'welcome': 'Welcome to PashuCare',
      'login': 'Login',
      'register': 'Register',
      'phone': 'Phone Number',
      'password': 'Password',
      'name': 'Full Name',
      'location': 'Location (Optional)',
      'no_account': "Don't have an account?",
      'have_account': 'Already have an account? Login here',
      'register_now': 'Register Now',
      'select_language': 'Select Language',
      'farm_certifications': 'Farm Certifications',
      'apply_new': 'Apply New',
      'my_animals': 'My Animals',
      'inventory': 'Inventory',
      'vet_services': 'Vet Services',
      'marketplace': 'Marketplace',
      'feed_mgmt': 'Feed Management',
      'milk_sales': 'Milk Sales',
      'govt_schemes': 'Govt Schemes',
      'finance': 'Finance',
      'insurance': 'Insurance',
      'loans': 'Loans & Finance',
      'certifications': 'Certifications',
    },
    'ml': {
      'welcome': 'പശു കെയറിലേക്ക് സ്വാഗതം',
      'login': 'ലോഗിൻ',
      'register': 'രജിസ്റ്റർ',
      'phone': 'ഫോൺ നമ്പർ',
      'password': 'പാസ്‌വേഡ്',
      'name': 'മുഴുവൻ പേര്',
      'location': 'സ്ഥലം (നിർബന്ധമില്ല)',
      'no_account': "അക്കൗണ്ട് ഇല്ലേ?",
      'have_account': 'അക്കൗണ്ട് ഉണ്ടോ? ഇവിടെ ലോഗിൻ ചെയ്യുക',
      'register_now': 'ഇപ്പോൾ രജിസ്റ്റർ ചെയ്യുക',
      'select_language': 'ഭാഷ തിരഞ്ഞെടുക്കുക',
      'farm_certifications': 'ഫാം സർട്ടിഫിക്കേഷനുകൾ',
      'apply_new': 'പുതിയത് അപേക്ഷിക്കുക',
      'my_animals': 'എന്റെ മൃഗങ്ങൾ',
      'inventory': 'ഇൻവെന്ററി',
      'vet_services': 'വെറ്ററിനറി സേവനങ്ങൾ',
      'marketplace': 'മാർക്കറ്റ് പ്ലേസ്',
      'feed_mgmt': 'തീറ്റ മാനേജ്മെന്റ്',
      'milk_sales': 'പാൽ വിൽപ്പന',
      'govt_schemes': 'ഗവൺമെന്റ് പദ്ധതികൾ',
      'finance': 'ഫിനാൻസ്',
      'insurance': 'ഇൻഷുറൻസ്',
      'loans': 'ലോണുകൾ & ഫിനാൻസ്',
      'certifications': 'സർട്ടിഫിക്കേഷനുകൾ',
    },
    'hi': {
      'welcome': 'पशुकेयर में आपका स्वागत है',
      'login': 'लॉगिन',
      'register': 'पंजीकरण',
      'phone': 'फ़ोन नंबर',
      'password': 'पासवर्ड',
      'name': 'पूरा नाम',
      'location': 'स्थान (वैकल्पिक)',
      'no_account': 'खाता नहीं है?',
      'have_account': 'पहले से ही एक खाता है? यहाँ लॉगिन करें',
      'register_now': 'अभी पंजीकरण करें',
      'select_language': 'भाषा चुनें',
      'farm_certifications': 'फार्म प्रमाणपत्र',
      'apply_new': 'नया लागू करें',
      'my_animals': 'मेरे पशु',
      'inventory': 'माल सूची',
      'vet_services': 'पशु चिकित्सक सेवाएँ',
      'marketplace': 'बाज़ार',
      'feed_mgmt': 'चारा प्रबंधन',
      'milk_sales': 'दूध की बिक्री',
      'govt_schemes': 'सरकारी योजनाएं',
      'finance': 'वित्त',
      'insurance': 'बीमा',
      'loans': 'ऋण और वित्त',
      'certifications': 'प्रमाणपत्र',
    },
    // Add other languages as needed...
  };

  String translate(String key) {
    return _translations[_locale.languageCode]?[key] ?? _translations['en']?[key] ?? key;
  }
}
