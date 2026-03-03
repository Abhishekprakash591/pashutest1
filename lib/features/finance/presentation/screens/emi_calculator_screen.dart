import 'package:flutter/material.dart';
import '../../data/models/loan_model.dart';
import 'dart:math';

class EMICalculatorScreen extends StatefulWidget {
  final LoanProduct loan;

  const EMICalculatorScreen({super.key, required this.loan});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  late double _amount;
  late double _tenure;
  double _emi = 0;

  @override
  void initState() {
    super.initState();
    _amount = widget.loan.maxAmount / 2; // Default to half max
    _tenure = widget.loan.tenureMonths.toDouble();
    _calculateEMI();
  }

  void _calculateEMI() {
    // EMI = [P x R x (1+R)^N]/[(1+R)^N-1]
    // R = annual rate / 12 / 100
    
    double p = _amount;
    double r = widget.loan.interestRate / 12 / 100;
    double n = _tenure;

    if (r == 0) {
      _emi = p / n;
    } else {
      _emi = (p * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(widget.loan.loanName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 5),
                    Text('${widget.loan.bankName} • ${widget.loan.interestRate}% Interest', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('Loan Amount: ₹${_amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Slider(
              value: _amount,
              min: 50000,
              max: widget.loan.maxAmount,
              divisions: 100,
              label: _amount.round().toString(),
              onChanged: (value) {
                setState(() {
                  _amount = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Tenure: ${_tenure.toStringAsFixed(0)} Months', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Slider(
              value: _tenure,
              min: 12,
              max: widget.loan.tenureMonths.toDouble(),
              divisions: (widget.loan.tenureMonths - 12),
              label: _tenure.round().toString(),
              onChanged: (value) {
                setState(() {
                  _tenure = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text('Estimated Monthly EMI', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                    '₹${_emi.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildSummaryRow('Total Principal', '₹${_amount.toStringAsFixed(0)}'),
                  const SizedBox(height: 10),
                  _buildSummaryRow('Total Interest', '₹${((_emi * _tenure) - _amount).toStringAsFixed(0)}'),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildSummaryRow('Total Amount Payable', '₹${(_emi * _tenure).toStringAsFixed(0)}', isTotal: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14)),
        Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14, color: isTotal ? Colors.blue : Colors.black)),
      ],
    );
  }
}
