import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/models/animal_model.dart';
import '../providers/animal_provider.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  const AnimalDetailScreen({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to Edit Screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit feature coming next!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal Image / Placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: animal.photos.isNotEmpty
                  ? Image.network(animal.photos.first, fit: BoxFit.cover)
                  : const Icon(Icons.pets, size: 100, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Tag ID', animal.tagId),
                  _buildDetailRow('Species', animal.species),
                  if (animal.breed != null) _buildDetailRow('Breed', animal.breed!),
                  _buildDetailRow('Sex', animal.sex),
                  if (animal.dob != null) 
                    _buildDetailRow('DOB', DateFormat('yyyy-MM-dd').format(animal.dob!)),

                  if (animal.weight != null) _buildDetailRow('Weight', '${animal.weight} kg'),
                  const Divider(),
                  _buildDetailRow('Health Status', animal.healthStatus),
                  _buildDetailRow('Production Status', animal.productionStatus),
                  if (animal.milkCapacity != null)
                    _buildDetailRow('Milk Capacity', '${animal.milkCapacity} L/day'),
                  if (animal.lastVaccinationDate != null)
                    _buildDetailRow('Last Vaccination', DateFormat('dd MMM yyyy').format(animal.lastVaccinationDate!)),
                  if (animal.notes != null) ...[
                    const Divider(),
                    const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(animal.notes!),
                  ],
                  const Divider(),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        const Text('Animal QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        QrImageView(
                          data: animal.tagId,
                          version: QrVersions.auto,
                          size: 150.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text('Tag ID: ${animal.tagId}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Animal?'),
        content: Text('Are you sure you want to delete ${animal.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog
              await Provider.of<AnimalProvider>(context, listen: false).deleteAnimal(animal.id);
              if (context.mounted) {
                context.pop(); // Go back to list
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
