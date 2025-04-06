import 'package:flutter/material.dart';

import 'Screens/Home/home.dart';
import 'Screens/Authentication/login.dart';
import 'Screens/Data/resources.dart';
import 'Screens/Authentication/signup.dart';
import 'Screens/Data/singleuser.dart';
import 'Screens/Data/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReqRes API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/users': (context) => const UsersScreen(),
        '/single-user': (context) => const SingleUserScreen(),
        '/resources': (context) => const ResourcesScreen(),
      },
    );
  }
}


