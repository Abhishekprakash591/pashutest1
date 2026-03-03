import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../../data/models/transaction_model.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanceProvider>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense & Profit Tracker')),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = provider.summary;
          final income = (summary['income'] ?? 0).toDouble();
          final expense = (summary['expense'] ?? 0).toDouble();
          final profit = (summary['profit'] ?? 0).toDouble();
          final month = summary['month'] ?? 'Current Month';

          return RefreshIndicator(
            onRefresh: () => provider.fetchData(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(month, income, expense, profit),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: const Text('View All')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTransactionList(provider.transactions),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-transaction'),
        label: const Text('Add Entry'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSummaryCard(String month, double income, double expense, double profit) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(month, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              '₹${profit.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Text('Net Profit', style: TextStyle(color: Colors.white70)),
            const Divider(color: Colors.white24, height: 30),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Income', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 5),
                      Text('₹${income.toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Expense', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 5),
                      Text('₹${expense.toStringAsFixed(0)}', style: const TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No transactions yet.', style: TextStyle(color: Colors.grey))));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isIncome = tx.type == 'Income';
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isIncome ? Colors.green.shade50 : Colors.red.shade50,
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            title: Text(tx.category, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('dd MMM').format(tx.date)),
            trailing: Text(
              '${isIncome ? '+' : '-'} ₹${tx.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
