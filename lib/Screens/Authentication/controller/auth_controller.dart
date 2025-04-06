// login_provider.dart
import 'package:flutter/material.dart';
import '../../../services/apiservice.dart';
import '../../../services/authservice.dart';

class AuthProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthProvider() {
    checkLoginStatus();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    return isLoggedIn;
  }

  void clearError() {
    errorMessage = '';
    notifyListeners();
  }

  // Input validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // Login functionality
  Future<bool> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // NOTE: For ReqRes API, use eve.holt@reqres.in with any password
      final result = await ApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      await AuthService.saveToken(result['token']);
      isLoading = false;
      notifyListeners();

      // Navigate to home screen
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(BuildContext context) async {
    print("yes i am here");
if (!formKey.currentState!.validate()) {
      return false;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // NOTE: For ReqRes API, use eve.holt@reqres.in with any password
      final result = await ApiService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      await AuthService.saveToken(result['token']);
      isLoading = false;
      notifyListeners();

      // Navigate to home screen
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
}
}