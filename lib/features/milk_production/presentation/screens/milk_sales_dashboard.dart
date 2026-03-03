import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/milk_sale_provider.dart';
import '../../data/models/milk_sale_model.dart';

class MilkSalesDashboard extends StatefulWidget {
  const MilkSalesDashboard({super.key});

  @override
  State<MilkSalesDashboard> createState() => _MilkSalesDashboardState();
}

class _MilkSalesDashboardState extends State<MilkSalesDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MilkSaleProvider>(context, listen: false).fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Milk Collection Center')),
      body: Consumer<MilkSaleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());

          final stats = provider.monthlyStats;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(stats),
                const SizedBox(height: 24),
                const Text('Recent Sales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildSalesList(provider.sales),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/record-milk-sale'),
        label: const Text('Record Sale'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> stats) {
    // Handling potential nulls or incorrect types safely
    final earnings = (stats['totalEarnings'] ?? 0).toDouble();
    final liters = (stats['totalLiters'] ?? 0).toDouble();
    final avgFat = (stats['avgFat'] ?? 0).toDouble();

    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('This Month Earnings', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              '₹${earnings.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Milk', '${liters.toStringAsFixed(1)} L'),
                _buildStatItem('Avg Fat', '${avgFat.toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSalesList(List<MilkSale> sales) {
    if (sales.isEmpty) {
      return const Center(child: Text('No sales recorded yet.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(sale.shift[0], style: TextStyle(color: Colors.blue.shade900)),
            ),
            title: Text('${DateFormat('MMM dd').format(sale.saleDate)} • ${sale.quantityLiters} L'),
            subtitle: Text('Fat: ${sale.fatContent}% • ₹${sale.pricePerLiter}/L'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${sale.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(sale.paymentStatus, style: TextStyle(fontSize: 10, color: sale.paymentStatus == 'Pending' ? Colors.orange : Colors.green)),
              ],
            ),
          ),
        );
      },
    );
  }
}
