import 'package:flutter/material.dart';

import 'userdialog.dart';

Widget buildFeatureCard(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
  String route, {
  bool isDialog = false,
}) {
  return Card(
    elevation: 4,
    child: InkWell(
      onTap: () {
        if (isDialog) {
          showCreateUserDialog(context);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
