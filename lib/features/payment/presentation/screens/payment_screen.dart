import 'package:flutter/material.dart';
import '../../data/services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String note;
  final String payeeName;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.note,
    this.payeeName = 'Pashucare Seller',
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _service = PaymentService();
  final _vpaController = TextEditingController(); // In real app, this might be pre-filled or fetched
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // For demo, pre-fill a test VPA
    _vpaController.text = 'seller@upi';
  }

  Future<void> _initiatePayment() async {
    if (_vpaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter UPI ID')));
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await _service.launchUPI(
        upiId: _vpaController.text,
        name: widget.payeeName,
        amount: widget.amount,
        note: widget.note,
      );
      
      // We can't easily get callback success from external app intent without advanced plugins.
      // So we just simulate success message for demo.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.payment, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text('Paying to ${widget.payeeName}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            Text('₹${widget.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Note: ${widget.note}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            TextField(
              controller: _vpaController,
              decoration: const InputDecoration(
                labelText: 'Payee UPI ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _initiatePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.send),
                label: const Text('Pay with UPI App', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This will open any installed UPI app (GPay, PhonePe, Paytm, BHIM) to complete the transaction.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
