import 'package:collaborative_shopping_list/controllers/auth_controller.dart';
import 'package:collaborative_shopping_list/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller here
    final auth = Get.put(AuthController(), permanent: true);
    print('AuthWrapper built, user: ${auth.user.value?.uid ?? "null"}');
    return Obx(() {
      print('Obx triggered, user: ${auth.user.value?.uid ?? "null"}');
      if (auth.user.value == null) {
        return const LoginScreen();
      } else {
        return const Center(child: Text('Dashboard Placeholder'));
      }
    });
  }
}