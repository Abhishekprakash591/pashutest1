import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/insurance_provider.dart';

class InsuranceListScreen extends StatefulWidget {
  const InsuranceListScreen({super.key});

  @override
  State<InsuranceListScreen> createState() => _InsuranceListScreenState();
}

class _InsuranceListScreenState extends State<InsuranceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InsuranceProvider>(context, listen: false).fetchPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livestock Insurance')),
      body: Consumer<InsuranceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.plans.isEmpty) {
            return const Center(child: Text('No insurance plans available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.plans.length,
            itemBuilder: (context, index) {
              final plan = provider.plans[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              plan.providerName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${plan.coverageDurationMonths} Months',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(plan.planName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(plan.description, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.verified_user_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Premium Rate: ${plan.premiumRate}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                           Text(
                            'Max: ₹${plan.maxCoverageAmount ~/ 1000}k',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.push('/insurance-calculator', extra: plan);
                          },
                          icon: const Icon(Icons.calculate),
                          label: const Text('Calculate Premium & Apply'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
