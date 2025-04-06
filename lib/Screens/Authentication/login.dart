import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider.value for stateless widget implementation
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  const LoginScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Check login status when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = await provider.checkLoginStatus();
      if (isLoggedIn && context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: provider.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LoginHeader(),
              if (provider.errorMessage.isNotEmpty) 
                ErrorMessage(message: provider.errorMessage),
              EmailField(provider: provider),
              const SizedBox(height: 20),
              PasswordField(provider: provider),
              const SizedBox(height: 20),
              LoginButton(provider: provider),
              const SizedBox(height: 20),
              const SignUpLink(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.lock_outline, size: 80, color: Colors.blue),
        SizedBox(height: 40),
      ],
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;
  
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.red.shade100,
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  final AuthProvider provider;
  
  const EmailField({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: provider.emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
        hintText: 'eve.holt@reqres.in',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: provider.validateEmail,
    );
  }
}

class PasswordField extends StatelessWidget {
  final AuthProvider provider;
  
  const PasswordField({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: provider.passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
        hintText: 'Any password works with demo account',
      ),
      obscureText: true,
      validator: provider.validatePassword,
    );
  }
}

class LoginButton extends StatelessWidget {
  final AuthProvider provider;
  
  const LoginButton({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : () => provider.login(context),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('LOGIN', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class SignUpLink extends StatelessWidget {
  const SignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/signup');
      },
      child: const Text('Don\'t have an account? Sign Up'),
    );
  }
}