import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../../data/models/outbreak_model.dart';

class OutbreakMapScreen extends StatefulWidget {
  const OutbreakMapScreen({super.key});

  @override
  State<OutbreakMapScreen> createState() => _OutbreakMapScreenState();
}

class _OutbreakMapScreenState extends State<OutbreakMapScreen> {
  GoogleMapController? _mapController;
  final LatLng _center = const LatLng(20.5937, 78.9629); // Center of India
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthProvider>(context, listen: false).fetchOutbreaks();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateMarkersAndCircles(List<OutbreakReport> reports) {
    _markers.clear();
    _circles.clear();

    for (var report in reports) {
      final position = LatLng(report.latitude, report.longitude);
      final isCritical = report.severity == 'Critical' || report.severity == 'High';

      _markers.add(
        Marker(
          markerId: MarkerId(report.id),
          position: position,
          infoWindow: InfoWindow(
            title: report.diseaseName,
            snippet: 'Severity: ${report.severity} • ${report.reportedAt.day}/${report.reportedAt.month}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isCritical ? BitmapDescriptor.hueRed : BitmapDescriptor.hueOrange,
          ),
        ),
      );

      _circles.add(
        Circle(
          circleId: CircleId('${report.id}_circle'),
          center: position,
          radius: isCritical ? 5000 : 2000, // Radius in meters
          fillColor: (isCritical ? Colors.red : Colors.orange).withOpacity(0.3),
          strokeWidth: 1,
          strokeColor: isCritical ? Colors.red : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Outbreak Heatmap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<HealthProvider>(context, listen: false).fetchOutbreaks(),
          ),
        ],
      ),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          _updateMarkersAndCircles(provider.outbreakReports);

          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: provider.outbreakReports.isNotEmpty
                      ? LatLng(provider.outbreakReports.first.latitude, provider.outbreakReports.first.longitude)
                      : _center,
                  zoom: 5.0,
                ),
                markers: _markers,
                circles: _circles,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator()),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Showing ${provider.outbreakReports.length} reported outbreaks.',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildLegend(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Positioned(
      bottom: 100,
      left: 16,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Legend', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              _legendItem(Colors.red, 'High / Critical Risk'),
              _legendItem(Colors.orange, 'Medium Risk'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
