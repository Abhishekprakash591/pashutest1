import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/feed_provider.dart';
import 'package:pashucare_app/features/inventory_management/presentation/providers/inventory_provider.dart';
import 'package:pashucare_app/features/inventory_management/data/models/inventory_item_model.dart';

class FeedDashboardScreen extends StatefulWidget {
  const FeedDashboardScreen({super.key});

  @override
  State<FeedDashboardScreen> createState() => _FeedDashboardScreenState();
}

class _FeedDashboardScreenState extends State<FeedDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeedProvider>(context, listen: false).fetchFeedHistory();
      Provider.of<InventoryProvider>(context, listen: false).fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed Management')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStockOverview(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
            const SizedBox(height: 8),
            _buildRecentLogs(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/log-feed'),
        label: const Text('Log Feeding'),
        icon: const Icon(Icons.add_task),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStockOverview(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        final feedItems = provider.items.where((item) => item.category == 'Feed').toList();

        if (feedItems.isEmpty) {
          return Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No Feed Items in Inventory. Add some first!'),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current Stock', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: feedItems.length,
                separatorBuilder: (c, i) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _buildStockCard(feedItems[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStockCard(InventoryItem item) {
    bool isLow = item.quantity <= item.lowStockThreshold;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isLow ? Colors.red.shade200 : Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.grass, color: isLow ? Colors.red : Colors.green, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${item.quantity} ${item.unit}',
                style: TextStyle(
                  color: isLow ? Colors.red : Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLogs(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.logs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No feeding records yet.', style: TextStyle(color: Colors.grey)),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.logs.length,
          itemBuilder: (context, index) {
            final log = provider.logs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.brown.shade100,
                  child: const Icon(Icons.history, color: Colors.brown),
                ),
                title: Text('${log.inventoryItemName} (${log.quantity} ${log.unit})'),
                subtitle: Text(
                  '${log.activityType} • ${log.animalName ?? "General"}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  '₹${log.cost.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
