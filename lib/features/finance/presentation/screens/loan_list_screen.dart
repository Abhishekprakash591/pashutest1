import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/loan_provider.dart';
import '../../data/models/loan_model.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoanProvider>(context, listen: false).fetchLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loans & Finance')),
      body: Consumer<LoanProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildFilterChips(provider),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.loans.isEmpty
                        ? const Center(child: Text('No loans found.'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: provider.loans.length,
                            itemBuilder: (context, index) {
                              return _LoanCard(loan: provider.loans[index]);
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(LoanProvider provider) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: ['All', 'Dairy', 'Equipment', 'General'].map((filter) {
          final isSelected = provider.filter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) provider.setFilter(filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final LoanProduct loan;

  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loan.bankName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(loan.loanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(loan.description),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfo('Interest', '${loan.interestRate}%', Colors.red),
                _buildInfo('Max Amount', '₹${loan.maxAmount ~/ 100000} Lakh', Colors.black),
                _buildInfo('Tenure', '${loan.tenureMonths} mo', Colors.black),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/emi-calculator', extra: loan);
                    },
                    child: const Text('EMI Calculator'),
                  ),
                ),
                if (loan.applicationLink != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                         final uri = Uri.parse(loan.applicationLink!);
                         if(await canLaunchUrl(uri)) await launchUrl(uri);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Apply Now'),
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ],
    );
  }
}
