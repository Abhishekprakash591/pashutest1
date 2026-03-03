import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/certification_provider.dart';

class ApplyCertificationScreen extends StatefulWidget {
  const ApplyCertificationScreen({super.key});

  @override
  State<ApplyCertificationScreen> createState() => _ApplyCertificationScreenState();
}

class _ApplyCertificationScreenState extends State<ApplyCertificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _certificationName = '';
  String _authority = '';
  String _notes = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        await Provider.of<CertificationProvider>(context, listen: false).applyForCertification({
          'certificationName': _certificationName,
          'authority': _authority,
          'notes': _notes,
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Application submitted successfully!'), backgroundColor: Colors.green),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting application: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Certification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Professional certification helps you get better prices and government support.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Certification Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment),
                  helperText: 'e.g., Organic Farm Certification, Quality Grade A',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _certificationName = value!,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Issuing Authority',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                  helperText: 'e.g., FSSAI, ISO, State Agriculture Dept',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the authority' : null,
                onSaved: (value) => _authority = value!,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Additional Notes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                onSaved: (value) => _notes = value ?? '',
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit Application', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
