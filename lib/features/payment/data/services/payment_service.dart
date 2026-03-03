import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  
  // Launches UPI intent
  Future<void> launchUPI({
    required String upiId,
    required String name,
    required double amount,
    required String note,
  }) async {
    // Basic UPI Intent Schema
    // upi://pay?pa=<vpa>&pn=<name>&am=<amount>&tn=<note>&cu=INR
    
    final uri = Uri.parse(
      'upi://pay?pa=$upiId&pn=$name&am=${amount.toStringAsFixed(2)}&tn=$note&cu=INR'
    );

    try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback: Sometimes android doesn't report canLaunch correctly for schemes
          // Try launching anyway
           await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
    } catch (e) {
      debugPrint('Error launching UPI: $e');
      throw Exception('Could not launch payment app');
    }
  }
}
