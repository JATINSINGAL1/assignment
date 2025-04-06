import 'package:flutter/material.dart';
import '../../services/apiservice.dart';

// not using controller here as the file is simple and does not need 

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  late Future<Map<String, dynamic>> _resourcesFuture;

  @override
  void initState() {
    super.initState();
    _resourcesFuture = ApiService.getResources();
  }

  Future<void> _refreshResources() async {
    setState(() {
      _resourcesFuture = ApiService.getResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources (Colors)')),
      body: RefreshIndicator(
        onRefresh: _refreshResources,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _resourcesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || (snapshot.data!['data'] as List).isEmpty) {
              return const Center(child: Text('No resources found'));
            }

            final resources = snapshot.data!['data'] as List;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final resource = resources[index];
                final color = _hexToColor(resource['color']);

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showResourceDetailsDialog(context, resource);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          resource['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource['color'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Year: ${resource['year']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _hexToColor(String hexString) {
    final hexColor = hexString.replaceAll('#', '');
    if (hexColor.length == 6) {
      return Color(int.parse('FF$hexColor', radix: 16));
    }
    return Colors.black;
  }

  void _showResourceDetailsDialog(BuildContext context, dynamic resource) {
    final color = _hexToColor(resource['color']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(resource['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(height: 16),
              Text('ID: ${resource['id']}'),
              const SizedBox(height: 8),
              Text('Name: ${resource['name']}'),
              const SizedBox(height: 8),
              Text('Year: ${resource['year']}'),
              const SizedBox(height: 8),
              Text('Color: ${resource['color']}'),
              const SizedBox(height: 8),
              Text('Pantone value: ${resource['pantone_value']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
