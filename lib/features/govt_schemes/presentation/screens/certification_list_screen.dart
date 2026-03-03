import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/certification_provider.dart';

class CertificationListScreen extends StatefulWidget {
  const CertificationListScreen({super.key});

  @override
  State<CertificationListScreen> createState() => _CertificationListScreenState();
}

class _CertificationListScreenState extends State<CertificationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CertificationProvider>(context, listen: false).fetchCertifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Certifications')),
      body: Consumer<CertificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          
          if (provider.certifications.isEmpty) {
            return const Center(child: Text('No certifications applied yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.certifications.length,
            itemBuilder: (context, index) {
              final cert = provider.certifications[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(cert.status).withOpacity(0.1),
                    child: Icon(Icons.verified, color: _getStatusColor(cert.status)),
                  ),
                  title: Text(cert.certificationName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${cert.authority} • ${DateFormat('dd MMM yyyy').format(cert.applicationDate)}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(cert.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getStatusColor(cert.status)),
                    ),
                    child: Text(
                      cert.status,
                      style: TextStyle(color: _getStatusColor(cert.status), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/apply-certification'),
        label: const Text('Apply New'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved': return Colors.green;
      case 'Pending': return Colors.orange;
      case 'Rejected': return Colors.red;
      case 'In-Progress': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
