import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scheme_provider.dart';
import '../../data/models/scheme_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemeListScreen extends StatefulWidget {
  const SchemeListScreen({super.key});

  @override
  State<SchemeListScreen> createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SchemeProvider>(context, listen: false).fetchSchemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Government Schemes')),
      body: Consumer<SchemeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildFilterChips(provider),
              Expanded(
                child: provider.filteredSchemes.isEmpty
                    ? const Center(child: Text('No schemes found.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.filteredSchemes.length,
                        itemBuilder: (context, index) {
                          return _SchemeCard(scheme: provider.filteredSchemes[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(SchemeProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['All', 'Central', 'State'].map((filter) {
          final isSelected = provider.filter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) provider.setFilter(filter);
            },
            selectedColor: Colors.blue.shade100,
            labelStyle: TextStyle(
              color: isSelected ? Colors.blue.shade800 : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final Scheme scheme;

  const _SchemeCard({required this.scheme});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: scheme.type == 'Central' ? Colors.orange.shade100 : Colors.green.shade100,
          child: Icon(Icons.account_balance, color: scheme.type == 'Central' ? Colors.orange : Colors.green),
        ),
        title: Text(scheme.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(scheme.type, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSection('Description', scheme.description),
                const SizedBox(height: 10),
                _buildSection('Eligibility', scheme.eligibility),
                const SizedBox(height: 10),
                _buildSection('Benefits', scheme.benefits),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _launchURL(scheme.applicationLink),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Visit Official Website / Apply'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 2),
        Text(content, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
