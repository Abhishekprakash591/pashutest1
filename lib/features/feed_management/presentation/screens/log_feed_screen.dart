import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/feed_provider.dart';
import 'package:pashucare_app/features/inventory_management/presentation/providers/inventory_provider.dart';
import 'package:pashucare_app/features/animal_management/presentation/providers/animal_provider.dart';

class LogFeedScreen extends StatefulWidget {
  const LogFeedScreen({super.key});

  @override
  State<LogFeedScreen> createState() => _LogFeedScreenState();
}

class _LogFeedScreenState extends State<LogFeedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedInventoryItemId;
  String? _selectedAnimalId; // Optional
  String _activityType = 'Morning Feeding';

  final List<String> _activityTypes = [
    'Morning Feeding',
    'Evening Feeding',
    'Extra Supplement',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventoryProvider>(context, listen: false).fetchItems();
      Provider.of<AnimalProvider>(context, listen: false).fetchAnimals();
    });
  }

  Future<void> _submitLog() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await Provider.of<FeedProvider>(context, listen: false).logFeedUsage(
        inventoryItemId: _selectedInventoryItemId!,
        quantity: double.parse(_quantityController.text),
        animalId: _selectedAnimalId,
        activityType: _activityType,
        notes: _notesController.text,
      );

      // Refresh inventory to show updated stock
      if (mounted) {
        Provider.of<InventoryProvider>(context, listen: false).fetchItems();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feed usage logged successfully!'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log usage: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Feed Usage')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('What are you feeding?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInventoryDropdown(),
            const SizedBox(height: 20),
            const Text('Who are you feeding?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildAnimalDropdown(),
            const SizedBox(height: 20),
            const Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _activityType,
              decoration: InputDecoration(
                labelText: 'Activity Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: _activityTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _activityType = v!),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity Used',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixText: 'Units', // Can be dynamic based on selected item unit
              ),
              validator: (v) => v!.isEmpty ? 'Enter quantity' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryDropdown() {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const LinearProgressIndicator();

        // Filter only 'Feed' items
        final feedItems = provider.items.where((i) => i.category == 'Feed').toList();

        if (feedItems.isEmpty) {
          return const Text('No feed items in inventory used.', style: TextStyle(color: Colors.red));
        }

        return DropdownButtonFormField<String>(
          value: _selectedInventoryItemId,
          decoration: InputDecoration(
            labelText: 'Select Feed Item',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: feedItems.map((item) => DropdownMenuItem(
            value: item.id,
            child: Text('${item.name} (Avail: ${item.quantity} ${item.unit})'),
          )).toList(),
          onChanged: (v) => setState(() => _selectedInventoryItemId = v),
          validator: (v) => v == null ? 'Please select an item' : null,
        );
      },
    );
  }

  Widget _buildAnimalDropdown() {
    return Consumer<AnimalProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const LinearProgressIndicator();

        return DropdownButtonFormField<String>(
          value: _selectedAnimalId,
          decoration: InputDecoration(
            labelText: 'Select Animal (Optional)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'Leave empty for general feeding',
          ),
          items: [
             const DropdownMenuItem<String>(value: null, child: Text('Entire Herd / General')),
             ...provider.animals.map((a) => DropdownMenuItem(
              value: a.id,
              child: Text('${a.name} (${a.tagId})'),
            )),
          ],
          onChanged: (v) => setState(() => _selectedAnimalId = v),
        );
      },
    );
  }
}
