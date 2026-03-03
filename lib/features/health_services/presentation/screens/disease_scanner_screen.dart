import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/health_provider.dart';

class DiseaseScannerScreen extends StatefulWidget {
  const DiseaseScannerScreen({super.key});

  @override
  State<DiseaseScannerScreen> createState() => _DiseaseScannerScreenState();
}

class _DiseaseScannerScreenState extends State<DiseaseScannerScreen> {
  String? _selectedSpecies;
  final List<String> _selectedSymptoms = [];
  final List<String> _speciesOptions = ['Cow', 'Buffalo', 'Goat', 'Sheep', 'Poultry'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthProvider>(context, listen: false).fetchAvailableSymptoms();
    });
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  Future<void> _diagnose() async {
    if (_selectedSpecies == null || _selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select species and at least one symptom')),
      );
      return;
    }

    try {
      await Provider.of<HealthProvider>(context, listen: false).performDiagnosis(
        species: _selectedSpecies!,
        symptoms: _selectedSymptoms,
      );
      if (mounted) {
        context.push('/diagnosis-result');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diagnosis failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Disease Scanner'),
        actions: [
          TextButton(
            onPressed: _selectedSymptoms.isEmpty ? null : () => setState(() => _selectedSymptoms.clear()),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Identify potential health issues for your livestock.',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
                const SizedBox(height: 16),
                const Text('Step 1: Select Animal Species', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _speciesOptions.map((species) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(species),
                        selected: _selectedSpecies == species,
                        onSelected: (selected) {
                          setState(() => _selectedSpecies = selected ? species : null);
                        },
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading && provider.availableSymptoms.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                        child: Text(
                          'Step 2: Select Observed Symptoms',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: provider.availableSymptoms.length,
                          itemBuilder: (context, index) {
                            final symptom = provider.availableSymptoms[index];
                            final isSelected = _selectedSymptoms.contains(symptom);
                            return CheckboxListTile(
                              title: Text(symptom),
                              value: isSelected,
                              onChanged: (_) => _toggleSymptom(symptom),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _diagnose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: provider.isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Analyze Symptoms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
