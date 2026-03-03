import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/inventory_provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key});

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['All', 'Feed', 'Medicine', 'Equipment', 'Seed', 'Fertilizer'];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InventoryProvider>(context, listen: false);
      provider.fetchItems();
      provider.fetchAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search inventory...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: _onSearchChanged,
              )
            : const Text('Farm Inventory'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _onSearchChanged(''); // Reset search
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((e) => Tab(text: e)).toList(),
          onTap: (index) {
            setState(() {}); // Rebuild to filter list
          },
        ),
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentCategory = _categories[_tabController.index];
          final filteredItems = currentCategory == 'All' 
              ? provider.items 
              : provider.items.where((item) => item.category == currentCategory).toList();

          if (filteredItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No ${currentCategory == 'All' ? '' : currentCategory} items found.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/add-inventory'),
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Alerts Banner
              if (provider.totalAlerts > 0)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            '${provider.totalAlerts} Alert${provider.totalAlerts > 1 ? 's' : ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      if (provider.lowStockItems.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('🔴 ${provider.lowStockItems.length} Low Stock Items'),
                      ],
                      if (provider.expiredItems.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('⚠️ ${provider.expiredItems.length} Expired Items'),
                      ],
                      if (provider.expiringSoonItems.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('🟡 ${provider.expiringSoonItems.length} Expiring Soon'),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final isExpired = item.expiryDate != null && item.expiryDate!.isBefore(DateTime.now());
                    final isLowStock = item.quantity <= item.lowStockThreshold;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        side: (isExpired || isLowStock) 
                            ? BorderSide(color: isExpired ? Colors.red : Colors.orange, width: 2) 
                            : BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getColorForCategory(item.category).withOpacity(0.2),
                          child: Icon(_getIconForCategory(item.category), color: _getColorForCategory(item.category)),
                        ),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.quantity} ${item.unit} • ${item.category}'),
                            if (isLowStock)
                              const Text('⚠️ Low Stock', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            if (item.expiryDate != null)
                              Text(
                                'Expires: ${DateFormat('yyyy-MM-dd').format(item.expiryDate!)}',
                                style: TextStyle(color: isExpired ? Colors.red : Colors.grey),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () => _confirmDelete(context, item.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-inventory'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Provider.of<InventoryProvider>(context, listen: false).deleteItem(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Feed': return Icons.grass;
      case 'Medicine': return Icons.medication;
      case 'Equipment': return Icons.build;
      case 'Seed': return Icons.spa;
      case 'Fertilizer': return Icons.science;
      default: return Icons.category;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Feed': return Colors.green;
      case 'Medicine': return Colors.red;
      case 'Equipment': return Colors.blue;
      case 'Seed': return Colors.amber;
      case 'Fertilizer': return Colors.purple;
      default: return Colors.grey;
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<InventoryProvider>(context, listen: false).fetchItems(search: query);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
