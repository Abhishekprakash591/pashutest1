import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/vet_model.dart';
import '../../data/models/appointment_model.dart';
import '../providers/health_provider.dart';
import '../../../animal_management/presentation/providers/animal_provider.dart';
import '../../../animal_management/data/models/animal_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Vet vet;

  const BookAppointmentScreen({super.key, required this.vet});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  Animal? _selectedAnimal;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnimalProvider>(context, listen: false).fetchAnimals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Summary
              Card(
                color: Colors.green.shade50,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: widget.vet.profileImage.isNotEmpty 
                        ? NetworkImage(widget.vet.profileImage) 
                        : null,
                    child: widget.vet.profileImage.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  title: Text(widget.vet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(widget.vet.specialization),
                ),
              ),
              const SizedBox(height: 24),
              
              const Text('Select Animal', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Consumer<AnimalProvider>(
                builder: (context, animalProvider, child) {
                  return DropdownButtonFormField<Animal>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    hint: const Text('Choose an animal'),
                    value: _selectedAnimal,
                    items: animalProvider.animals.map((animal) {
                      return DropdownMenuItem(
                        value: animal,
                        child: Text('${animal.name} (${animal.tagId})'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedAnimal = value),
                    validator: (value) => value == null ? 'Please select an animal' : null,
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text('Appointment Date', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 12),
                      Text(DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Reason for Visit', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'e.g. Regular Checkup, Vaccination, Sick',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a reason' : null,
              ),
              const SizedBox(height: 20),

              const Text('Additional Notes', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Any symptoms or previous history...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Confirm Booking', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final appointment = Appointment(
        id: '', // Will be set by backend
        vet: widget.vet.id,
        animal: _selectedAnimal!.id,
        appointmentDate: _selectedDate,
        status: 'Pending',
        reason: _reasonController.text,
        notes: _notesController.text,
      );

      await Provider.of<HealthProvider>(context, listen: false).bookAppointment(appointment);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully!')),
        );
        context.pushReplacement('/my-appointments');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
