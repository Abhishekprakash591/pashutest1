import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pashucare_app/core/services/api_client.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final ApiClient _apiClient = ApiClient();

  static Future<void> initialize() async {
    try {
      // In a real app, you'd need the google-services.json for this to work
      // For now, we wrap in try-catch to prevent crashes if not configured
      await Firebase.initializeApp();
      
      // Request permission
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        
        // Get token
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          print('FCM Token: $token');
          await _registerToken(token);
        }

        // Listen for token refreshes
        _firebaseMessaging.onTokenRefresh.listen(_registerToken);

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Foreground message received: ${message.notification?.title}');
          // You could show a snackbar or local notification here
        });
      }
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  }

  static Future<void> _registerToken(String token) async {
    try {
      await _apiClient.put('/farmers/fcm-token', {'token': token});
      print('FCM Token registered with backend');
    } catch (e) {
      print('Failed to register FCM token: $e');
    }
  }
}
