import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/vet_model.dart';
import '../../../animal_management/data/models/animal_model.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthProvider>(context, listen: false).fetchAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_note, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No bookings yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Find a Doctor'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.appointments.length,
            itemBuilder: (context, index) {
              final appointment = provider.appointments[index];
              return _buildAppointmentCard(context, appointment);
            },
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Appointment appointment) {
    // Determine status color
    Color statusColor = Colors.orange;
    if (appointment.status == 'Confirmed') statusColor = Colors.green;
    if (appointment.status == 'Cancelled') statusColor = Colors.red;
    if (appointment.status == 'Completed') statusColor = Colors.blue;

    final vet = appointment.vet is Vet ? appointment.vet as Vet : null;
    final animal = appointment.animal is Animal ? appointment.animal as Animal : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Text(
                  DateFormat('dd MMM, yyyy').format(appointment.appointmentDate),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  vet?.name ?? 'Doctor Name',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.pets, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text('Animal: ${animal?.name ?? 'Unknown'} (${animal?.tagId ?? 'N/A'})'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Reason: ${appointment.reason}')),
              ],
            ),
            if (appointment.status == 'Pending') ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _confirmCancel(context, appointment.id),
                    child: const Text('Cancel Booking', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
            if (appointment.status == 'Completed' && vet != null) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.push('/add-review', extra: vet),
                    icon: const Icon(Icons.star_outline, size: 18),
                    label: const Text('Rate Doctor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<HealthProvider>(context, listen: false).cancelAppointment(id);
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
