import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pashucare_app/core/constants/app_colors.dart';
import 'package:pashucare_app/core/constants/app_strings.dart';
import 'package:pashucare_app/core/routing/app_router.dart';
import 'features/animal_management/presentation/providers/animal_provider.dart';
import 'features/inventory_management/presentation/providers/inventory_provider.dart';
import 'features/health_services/presentation/providers/health_provider.dart';
import 'features/marketplace/presentation/providers/marketplace_provider.dart';
import 'features/feed_management/presentation/providers/feed_provider.dart';
import 'features/milk_production/presentation/providers/milk_sale_provider.dart';
import 'features/govt_schemes/presentation/providers/scheme_provider.dart';
import 'features/finance/presentation/providers/finance_provider.dart';
import 'features/insurance/presentation/providers/insurance_provider.dart';
import 'features/finance/presentation/providers/loan_provider.dart';
import 'features/govt_schemes/presentation/providers/certification_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pashucare_app/core/providers/locale_provider.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const PashucareApp());
}

class PashucareApp extends StatelessWidget {
  const PashucareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnimalProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => MilkSaleProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
        ChangeNotifierProvider(create: (_) => InsuranceProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => CertificationProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: AppStrings.appName,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            routerConfig: router,
            locale: context.watch<LocaleProvider>().locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('mr'),
              Locale('gu'),
              Locale('pa'),
              Locale('ta'),
              Locale('te'),
              Locale('kn'),
              Locale('ml'),
            ],
          );
        },
      ),
    );
  }
}
