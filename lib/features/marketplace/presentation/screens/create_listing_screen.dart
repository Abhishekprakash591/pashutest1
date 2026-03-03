import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/marketplace_provider.dart';
import '../../data/models/listing_model.dart';
import '../../../animal_management/presentation/providers/animal_provider.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedCategory = 'Milk';
  final List<String> _categories = ['Animal', 'Milk', 'Feed', 'Equipment', 'Other'];
  String? _selectedAnimalId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimalProvider>(context, listen: false).fetchAnimals();
    });
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final listing = MarketplaceListing(
        id: '',
        sellerId: '', // Handled by backend
        sellerName: '', // Handled by backend
        sellerPhone: '', // Handled by backend
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        price: double.parse(_priceController.text),
        images: [], // TODO: Implementation of image picking
        location: _locationController.text,
        status: 'Available',
        animalRef: _selectedCategory == 'Animal' ? _selectedAnimalId : null,
        createdAt: DateTime.now(),
      );

      await Provider.of<MarketplaceProvider>(context, listen: false).createListing(listing);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing posted successfully!'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post listing: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post an Ad')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('What are you selling?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildCategoryDropdown(),
              if (_selectedCategory == 'Animal') ...[
                const SizedBox(height: 20),
                _buildAnimalDropdown(),
              ],
              const SizedBox(height: 25),
              const Text('Ad Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Listing Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: 'e.g. Fresh Buffalo Milk',
                ),
                validator: (v) => v!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: 'Describe what you are selling...',
                ),
                validator: (v) => v!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (₹)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (v) => v!.isEmpty ? 'Enter price' : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'City, State',
                      ),
                      validator: (v) => v!.isEmpty ? 'Enter location' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Post Ad Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: (v) => setState(() => _selectedCategory = v!),
    );
  }

  Widget _buildAnimalDropdown() {
    return Consumer<AnimalProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const CircularProgressIndicator();
        
        return DropdownButtonFormField<String>(
          value: _selectedAnimalId,
          decoration: InputDecoration(
            labelText: 'Select Animal',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: provider.animals.map((a) => DropdownMenuItem(
            value: a.id,
            child: Text('${a.name} (${a.species} - ${a.tagId})'),
          )).toList(),
          onChanged: (v) => setState(() => _selectedAnimalId = v),
          validator: (v) => _selectedCategory == 'Animal' && v == null ? 'Select an animal' : null,
        );
      },
    );
  }
}
