import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/animal_provider.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch animals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimalProvider>(context, listen: false).fetchAnimals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Livestock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => context.push('/scan-qr'),
          ),
        ],
      ),
      body: Consumer<AnimalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.animals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.pets, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No animals added yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/add-animal'),
                    child: const Text('Add Your First Animal'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.animals.length,
            itemBuilder: (context, index) {
              final animal = provider.animals[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: animal.photos.isNotEmpty 
                      ? NetworkImage(animal.photos.first) 
                      : null,
                    child: animal.photos.isEmpty ? Text(animal.name[0]) : null,
                  ),
                  title: Text(animal.name),
                  subtitle: Text('${animal.species} • ${animal.tagId}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/animal-detail', extra: animal),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-animal'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
