import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/health_provider.dart';
import '../../data/models/disease_model.dart';

class DiagnosisResultScreen extends StatelessWidget {
  const DiagnosisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);
    final results = provider.diagnosisResults;

    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis Insights')),
      body: results.isEmpty
          ? _buildNoResults(context)
          : Column(
              children: [
                _buildSafetyWarning(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return _buildResultCard(context, results[index]);
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Retake Scan'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/vet-list'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Consult Vet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyWarning() {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade50,
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'This is not a final diagnosis. Please consult a professional veterinarian for confirmed medical advice.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No matches found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We couldn\'t find a disease that matches these symptoms reliably.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Scanner'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, DiagnosisResult result) {
    final disease = result.disease;
    final isCritical = disease.severity == 'Critical' || disease.severity == 'High';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    disease.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCritical ? Colors.red.shade700 : Colors.green.shade800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(disease.severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _getSeverityColor(disease.severity)),
                  ),
                  child: Text(
                    result.matchPercentage.toInt().toString() + '% Match',
                    style: TextStyle(
                      color: _getSeverityColor(disease.severity),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (disease.isContagious)
              const Row(
                children: [
                  Icon(Icons.group_work, color: Colors.orange, size: 16),
                  SizedBox(width: 4),
                  Text('Highly Contagious - Isolate Animal', style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            const SizedBox(height: 16),
            const Text('Observed Match Symptoms:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: result.commonSymptoms.map((s) => Chip(
                label: Text(s, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.green.shade50,
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Prevention:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(disease.prevention, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(disease.treatment, style: const TextStyle(color: Colors.grey)),
            if (disease.isContagious) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _handleReportOutbreak(context, disease),
                  icon: const Icon(Icons.emergency_share, size: 18),
                  label: const Text('Report Outbreak'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleReportOutbreak(BuildContext context, Disease disease) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled. Please enable them to report.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
        }
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied.')),
        );
      }
      return;
    } 

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporting outbreak at your location...')),
      );
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      if (context.mounted) {
        await Provider.of<HealthProvider>(context, listen: false).reportOutbreak(
          diseaseId: disease.id,
          longitude: position.longitude,
          latitude: position.latitude,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Outbreak of ${disease.name} reported successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Map',
              textColor: Colors.white,
              onPressed: () => context.push('/outbreak-map'),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to report outbreak: $e')),
        );
      }
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange.shade900;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
