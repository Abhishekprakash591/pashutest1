import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  
  String _type = 'Expense';
  String? _category;
  DateTime _date = DateTime.now();

  final List<String> _expenseCategories = ['Feed', 'Medicine/Vet', 'Labor', 'Maintenance', 'Equipment', 'Other'];
  final List<String> _incomeCategories = ['Milk Sales', 'Animal Sales', 'Manure', 'Other'];

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a category')));
      return;
    }

    try {
      await Provider.of<FinanceProvider>(context, listen: false).addTransaction({
        'type': _type,
        'category': _category,
        'amount': double.parse(_amountController.text),
        'date': _date.toIso8601String(),
        'description': _descController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!'), backgroundColor: Colors.green));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentCategories = _type == 'Income' ? _incomeCategories : _expenseCategories;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
             Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Expense'),
                    value: 'Expense',
                    groupValue: _type,
                    activeColor: Colors.red,
                    onChanged: (v) => setState(() { _type = v.toString(); _category = null; }),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Income'),
                    value: 'Income',
                    groupValue: _type,
                    activeColor: Colors.green,
                    onChanged: (v) => setState(() { _type = v.toString(); _category = null; }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: currentCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Enter amount' : null,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now());
                if (d != null) setState(() => _date = d);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd MMM yyyy').format(_date)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900], foregroundColor: Colors.white),
                child: const Text('Save Transaction', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
