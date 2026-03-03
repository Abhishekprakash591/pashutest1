import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/health_provider.dart';
import '../../data/models/vet_model.dart';

class VetListScreen extends StatefulWidget {
  const VetListScreen({super.key});

  @override
  State<VetListScreen> createState() => _VetListScreenState();
}

class _AnimalHealthTabs extends StatelessWidget {
  final List<String> categories = ['Specialists', 'General', 'Poultry', 'Cattle'];
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: categories.map((cat) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(cat),
            onSelected: (_) {},
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class _VetListScreenState extends State<VetListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthProvider>(context, listen: false).fetchVets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/my-appointments'),
          ),
        ],
      ),
      body: Column(
        children: [
          _AnimalHealthTabs(),
          Expanded(
            child: Consumer<HealthProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.vets.isEmpty) {
                  return const Center(child: Text('No doctors available in your area.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.vets.length,
                  itemBuilder: (context, index) {
                    final vet = provider.vets[index];
                    return _buildVetCard(context, vet);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVetCard(BuildContext context, Vet vet) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: vet.profileImage.isNotEmpty 
                      ? NetworkImage(vet.profileImage) 
                      : null,
                  child: vet.profileImage.isEmpty ? const Icon(Icons.person, size: 40) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            vet.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          if (vet.isVerified)
                            const Icon(Icons.verified, color: Colors.blue, size: 18),
                        ],
                      ),
                      Text(vet.specialization, style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${vet.rating.toStringAsFixed(1)} (${vet.numReviews} Reviews) • ${vet.experience} years exp.'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text(vet.location, style: const TextStyle(fontSize: 14))),
                ElevatedButton(
                  onPressed: () => context.push('/book-appointment', extra: vet),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
