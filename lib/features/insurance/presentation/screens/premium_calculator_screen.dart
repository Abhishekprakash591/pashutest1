import 'package:flutter/material.dart';
import '../../data/models/insurance_model.dart';
import 'package:go_router/go_router.dart';

class PremiumCalculatorScreen extends StatefulWidget {
  final InsurancePlan plan;

  const PremiumCalculatorScreen({super.key, required this.plan});

  @override
  State<PremiumCalculatorScreen> createState() => _PremiumCalculatorScreenState();
}

class _PremiumCalculatorScreenState extends State<PremiumCalculatorScreen> {
  final _valueController = TextEditingController();
  final _tagController = TextEditingController();
  double _premium = 0;
  bool _calculated = false;

  void _calculate() {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid animal value')));
      return;
    }

    if (value > widget.plan.maxCoverageAmount) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Max coverage is ₹${widget.plan.maxCoverageAmount}')));
      return;
    }

    setState(() {
      _premium = (value * widget.plan.premiumRate) / 100;
      _calculated = true;
    });
  }

  void _apply() {
    // In a real app, this would submit an application to backend
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Application Submitted'),
        content: Text('Your application for ${widget.plan.planName} has been received. Our agent will contact you shortly.'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Go back to list
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(widget.plan.planName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('by ${widget.plan.providerName}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text('Premium Rate: ${widget.plan.premiumRate}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Enter Animal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: 'Ear Tag ID (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            const SizedBox(height: 20),
             TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Animal Market Value (₹)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
                helperText: 'Enter estimated market value',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text('Calculate Premium', style: TextStyle(fontSize: 18)),
            ),
            if (_calculated) ...[
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text('Estimated Annual Premium', style: TextStyle(color: Colors.green, fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(
                      '₹${_premium.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _apply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Apply for Policy'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
