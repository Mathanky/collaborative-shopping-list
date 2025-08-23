import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collaborative_shopping_list/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => authController.login(
                emailController.text,
                passwordController.text,
              ),
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => authController.signUp(
                emailController.text,
                passwordController.text,
              ),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}