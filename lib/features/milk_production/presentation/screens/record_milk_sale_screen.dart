import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/milk_sale_provider.dart';

class RecordMilkSaleScreen extends StatefulWidget {
  const RecordMilkSaleScreen({super.key});

  @override
  State<RecordMilkSaleScreen> createState() => _RecordMilkSaleScreenState();
}

class _RecordMilkSaleScreenState extends State<RecordMilkSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _fatController = TextEditingController();
  final _snfController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _shift = 'Morning';
  String _paymentStatus = 'Pending';

  Future<void> _recordSale() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await Provider.of<MilkSaleProvider>(context, listen: false).recordSale({
        'saleDate': _selectedDate.toIso8601String(),
        'shift': _shift,
        'quantityLiters': double.parse(_qtyController.text),
        'fatContent': double.tryParse(_fatController.text) ?? 0,
        'snf': double.tryParse(_snfController.text) ?? 0,
        'pricePerLiter': double.parse(_priceController.text),
        'paymentStatus': _paymentStatus,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sale recorded successfully!'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
  
  // Calculate total price preview
  double get _totalPrice {
    final qty = double.tryParse(_qtyController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    return qty * price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Milk Sale')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildDatePicker(),
              const SizedBox(height: 20),
              _buildShiftSelector(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity (Liters)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter quantity' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Fat %', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _snfController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SNF', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price / Liter (₹)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Enter price' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _paymentStatus,
                decoration: const InputDecoration(labelText: 'Payment Status', border: OutlineInputBorder()),
                items: ['Pending', 'Received', 'Partial'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _paymentStatus = v!),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('₹${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _recordSale,
                  child: const Text('Save Record', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        );
        if (d != null) setState(() => _selectedDate = d);
      },
      child: InputDecorator(
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Date'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftSelector() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            title: const Text('Morning'),
            value: 'Morning',
            groupValue: _shift,
            onChanged: (v) => setState(() => _shift = v.toString()),
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Evening'),
            value: 'Evening',
            groupValue: _shift,
            onChanged: (v) => setState(() => _shift = v.toString()),
          ),
        ),
      ],
    );
  }
}
