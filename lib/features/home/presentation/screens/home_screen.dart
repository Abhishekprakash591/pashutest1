import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pashucare_app/core/providers/locale_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = Provider.of<LocaleProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Pashucare Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _DashboardCard(
              title: lp.translate('my_animals'),
              icon: Icons.pets,
              color: Colors.green,
              onTap: () => context.push('/animal-list'),
            ),
            _DashboardCard(
              title: lp.translate('vet_services'),
              icon: Icons.local_hospital,
              color: Colors.green,
              onTap: () => context.push('/vet-list'),
            ),
            _DashboardCard(
              title: lp.translate('inventory'),
              icon: Icons.inventory,
              color: Colors.blue,
              onTap: () => context.push('/inventory-list'),
            ),
            _DashboardCard(
              title: 'AI Health Scanner',
              icon: Icons.psychology,
              color: Colors.teal,
              onTap: () => context.push('/disease-scanner'),
            ),
             _DashboardCard(
              title: lp.translate('marketplace'),
              icon: Icons.store,
              color: Colors.orange,
              onTap: () => context.push('/marketplace'),
            ),
            _DashboardCard(
              title: lp.translate('feed_mgmt'),
              icon: Icons.grass,
              color: Colors.brown,
              onTap: () => context.push('/feed-dashboard'),
            ),
            _DashboardCard(
              title: lp.translate('milk_sales'),
              icon: Icons.water_drop,
              color: Colors.blue,
              onTap: () => context.push('/milk-sales-dashboard'),
            ),
            _DashboardCard(
              title: lp.translate('govt_schemes'),
              icon: Icons.account_balance,
              color: Colors.purple,
              onTap: () => context.push('/schemes'),
            ),
            _DashboardCard(
              title: 'Disease Heatmap',
              icon: Icons.map,
              color: Colors.red,
              onTap: () => context.push('/outbreak-map'),
            ),
            _DashboardCard(
              title: 'Expense Tracker',
              icon: Icons.pie_chart,
              color: Colors.indigo,
              onTap: () => context.push('/finance-dashboard'),
            ),
            _DashboardCard(
              title: lp.translate('insurance'),
              icon: Icons.security,
              color: Colors.teal,
              onTap: () => context.push('/insurance-list'),
            ),
            _DashboardCard(
              title: lp.translate('loans'),
              icon: Icons.account_balance_wallet,
              color: Colors.deepPurple,
              onTap: () => context.push('/loan-list'),
            ),
            _DashboardCard(
              title: lp.translate('certifications'),
              icon: Icons.verified,
              color: Colors.orange,
              onTap: () => context.push('/certification-list'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
