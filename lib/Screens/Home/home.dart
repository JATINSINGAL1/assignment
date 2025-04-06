import 'package:flutter/material.dart';

import 'Widgets/featurecard.dart';
import '../../services/authservice.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReqRes API Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            buildFeatureCard(
              context,
              'Users List',
              Icons.people,
              Colors.blue,
              '/users',
            ),
            buildFeatureCard(
              context,
              'Single User',
              Icons.person,
              Colors.green,
              '/single-user',
            ),
            buildFeatureCard(
              context,
              'Resources',
              Icons.color_lens,
              Colors.purple,
              '/resources',
            ),
            buildFeatureCard(
              context,
              'Create User',
              Icons.person_add,
              Colors.orange,
              '/create-user',
              isDialog: true,
            ),
          ],
        ),
      ),
    );
  }
}
