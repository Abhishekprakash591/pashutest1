import 'package:go_router/go_router.dart';
import 'package:pashucare_app/features/auth/login_screen.dart';
import 'package:pashucare_app/features/auth/register_screen.dart';
import 'package:pashucare_app/features/auth/language_selection_screen.dart';
import 'package:pashucare_app/features/home/presentation/screens/home_screen.dart';
import 'package:pashucare_app/features/animal_management/presentation/screens/animal_list_screen.dart';
import 'package:pashucare_app/features/animal_management/presentation/screens/add_animal_screen.dart';
import 'package:pashucare_app/features/animal_management/presentation/screens/animal_detail_screen.dart';
import 'package:pashucare_app/features/animal_management/presentation/screens/qr_scanner_screen.dart';
import 'package:pashucare_app/features/animal_management/data/models/animal_model.dart';
import 'package:pashucare_app/features/inventory_management/presentation/screens/inventory_list_screen.dart';
import 'package:pashucare_app/features/inventory_management/presentation/screens/add_inventory_screen.dart';
import 'package:pashucare_app/features/health_services/presentation/screens/vet_list_screen.dart';
import 'package:pashucare_app/features/health_services/presentation/screens/book_appointment_screen.dart';
import 'package:pashucare_app/features/health_services/presentation/screens/my_appointments_screen.dart';
import 'package:pashucare_app/features/health_services/presentation/screens/add_review_screen.dart';
import 'package:pashucare_app/features/health_services/presentation/screens/outbreak_map_screen.dart';
import 'package:pashucare_app/features/marketplace/presentation/screens/marketplace_screen.dart';
import 'package:pashucare_app/features/marketplace/presentation/screens/listing_detail_screen.dart';
import 'package:pashucare_app/features/marketplace/presentation/screens/create_listing_screen.dart';
import 'package:pashucare_app/features/marketplace/data/models/listing_model.dart';
import 'package:pashucare_app/features/health_services/presentation/screens/disease_scanner_screen.dart';
import 'package:pashucare_app/features/feed_management/presentation/screens/feed_dashboard_screen.dart';
import 'package:pashucare_app/features/feed_management/presentation/screens/log_feed_screen.dart';
import 'package:pashucare_app/features/milk_production/presentation/screens/milk_sales_dashboard.dart';
import 'package:pashucare_app/features/milk_production/presentation/screens/record_milk_sale_screen.dart';
import 'package:pashucare_app/features/payment/presentation/screens/payment_screen.dart';
import 'package:pashucare_app/features/govt_schemes/presentation/screens/scheme_list_screen.dart';
import 'package:pashucare_app/features/finance/presentation/screens/finance_dashboard.dart';
import 'package:pashucare_app/features/finance/presentation/screens/add_transaction_screen.dart';
import 'package:pashucare_app/features/insurance/presentation/screens/insurance_list_screen.dart';
import 'package:pashucare_app/features/insurance/presentation/screens/premium_calculator_screen.dart';
import 'package:pashucare_app/features/insurance/data/models/insurance_model.dart'; 
import 'package:pashucare_app/features/finance/presentation/screens/loan_list_screen.dart';
import 'package:pashucare_app/features/finance/presentation/screens/emi_calculator_screen.dart';
import 'package:pashucare_app/features/finance/data/models/loan_model.dart';
import 'package:pashucare_app/features/govt_schemes/presentation/screens/certification_list_screen.dart';
import 'package:pashucare_app/features/govt_schemes/presentation/screens/apply_certification_screen.dart';
import 'package:pashucare_app/features/health_services/presentation/screens/diagnosis_result_screen.dart';
import 'package:pashucare_app/features/health_services/data/models/vet_model.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/language-selection',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/animal-list',
      builder: (context, state) => const AnimalListScreen(),
    ),
    GoRoute(
      path: '/add-animal',
      builder: (context, state) => const AddAnimalScreen(),
    ),
    GoRoute(
      path: '/scan-qr',
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
      path: '/animal-detail',
      builder: (context, state) {
        final animal = state.extra as Animal;
        return AnimalDetailScreen(animal: animal);
      },
    ),
    GoRoute(
      path: '/inventory-list',
      builder: (context, state) => const InventoryListScreen(),
    ),
    GoRoute(
      path: '/add-inventory',
      builder: (context, state) => const AddInventoryScreen(),
    ),
    GoRoute(
      path: '/vet-list',
      builder: (context, state) => const VetListScreen(),
    ),
    GoRoute(
      path: '/book-appointment',
      builder: (context, state) {
        final vet = state.extra as Vet;
        return BookAppointmentScreen(vet: vet);
      },
    ),
    GoRoute(
      path: '/my-appointments',
      builder: (context, state) => const MyAppointmentsScreen(),
    ),
    GoRoute(
      path: '/add-review',
      builder: (context, state) {
        final vet = state.extra as Vet;
        return AddReviewScreen(vet: vet);
      },
    ),
    GoRoute(
      path: '/disease-scanner',
      builder: (context, state) => const DiseaseScannerScreen(),
    ),
    GoRoute(
      path: '/diagnosis-result',
      builder: (context, state) => const DiagnosisResultScreen(),
    ),
    GoRoute(
      path: '/outbreak-map',
      builder: (context, state) => const OutbreakMapScreen(),
    ),
    GoRoute(
      path: '/marketplace',
      builder: (context, state) => const MarketplaceScreen(),
    ),
    GoRoute(
      path: '/listing-detail',
      builder: (context, state) {
        final listing = state.extra as MarketplaceListing;
        return ListingDetailScreen(listing: listing);
      },
    ),
    GoRoute(
      path: '/create-listing',
      builder: (context, state) => const CreateListingScreen(),
    ),
    GoRoute(
      path: '/feed-dashboard',
      builder: (context, state) => const FeedDashboardScreen(),
    ),
    GoRoute(
      path: '/log-feed',
      builder: (context, state) => const LogFeedScreen(),
    ),
    GoRoute(
      path: '/milk-sales-dashboard',
      builder: (context, state) => const MilkSalesDashboard(),
    ),
    GoRoute(
      path: '/record-milk-sale',
      builder: (context, state) => const RecordMilkSaleScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return PaymentScreen(
          amount: extra['amount'],
          note: extra['note'],
          payeeName: extra['payeeName'] ?? 'Seller',
        );
      },
    ),
    GoRoute(
      path: '/schemes',
      builder: (context, state) => const SchemeListScreen(),
    ),
    GoRoute(
      path: '/finance-dashboard',
      builder: (context, state) => const FinanceDashboard(),
    ),
    GoRoute(
      path: '/add-transaction',
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/insurance-list',
      builder: (context, state) => const InsuranceListScreen(),
    ),
    GoRoute(
      path: '/insurance-calculator',
      builder: (context, state) {
        final plan = state.extra as InsurancePlan;
        return PremiumCalculatorScreen(plan: plan);
      },
    ),
    GoRoute(
      path: '/loan-list',
      builder: (context, state) => const LoanListScreen(),
    ),
    GoRoute(
      path: '/emi-calculator',
      builder: (context, state) {
        final loan = state.extra as LoanProduct;
        return EMICalculatorScreen(loan: loan);
      },
    ),
    GoRoute(
      path: '/certification-list',
      builder: (context, state) => const CertificationListScreen(),
    ),
    GoRoute(
      path: '/apply-certification',
      builder: (context, state) => const ApplyCertificationScreen(),
    ),
  ],
);
