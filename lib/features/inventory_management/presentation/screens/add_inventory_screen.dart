import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/inventory_item_model.dart';
import '../providers/inventory_provider.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _lowStockThresholdController = TextEditingController(text: '10');
  final _costController = TextEditingController();
  final _purchaseDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _supplierController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Feed';
  final List<String> _categories = ['Feed', 'Medicine', 'Equipment', 'Seed', 'Fertilizer', 'Other'];

  DateTime? _purchaseDate;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    _purchaseDate = DateTime.now();
    _purchaseDateController.text = DateFormat('yyyy-MM-dd').format(_purchaseDate!);
  }

  Future<void> _selectDate(BuildContext context, bool isExpiry) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isExpiry ? DateTime.now().add(const Duration(days: 30)) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: isExpiry ? DateTime(2030) : DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isExpiry) {
          _expiryDate = picked;
          _expiryDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _purchaseDate = picked;
          _purchaseDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newItem = InventoryItem(
        id: '',
        name: _nameController.text,
        category: _selectedCategory,
        quantity: double.parse(_quantityController.text),
        lowStockThreshold: _lowStockThresholdController.text.isNotEmpty ? double.parse(_lowStockThresholdController.text) : 10,
        unit: _unitController.text,
        costPerUnit: _costController.text.isNotEmpty ? double.parse(_costController.text) : null,
        purchaseDate: _purchaseDate,
        expiryDate: _expiryDate,
        supplier: _supplierController.text.isNotEmpty ? _supplierController.text : null,
        farmerId: '',
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      try {
        await Provider.of<InventoryProvider>(context, listen: false).addItem(newItem);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully!')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add item: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Inventory Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name *'),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category *'),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity *'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                       decoration: const InputDecoration(labelText: 'Unit * (e.g., kg, L)'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lowStockThresholdController,
                decoration: const InputDecoration(
                  labelText: 'Low Stock Alert Threshold',
                  hintText: 'Alert when quantity is below this',
                  suffixIcon: Icon(Icons.warning_amber),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost per Unit (Optional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _purchaseDateController,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                       decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        suffixIcon: Icon(Icons.event_busy),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(labelText: 'Supplier (Optional)'),
              ),
               const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _lowStockThresholdController.dispose();
    _costController.dispose();
    _purchaseDateController.dispose();
    _expiryDateController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
