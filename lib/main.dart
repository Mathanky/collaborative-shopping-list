import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collaborative_shopping_list/screens/auth_screen.dart';
import 'package:collaborative_shopping_list/screens/shopping_list_screen.dart';
import 'package:collaborative_shopping_list/screens/payment_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Stripe with your publishable key
  Stripe.publishableKey = 'your_stripe_publishable_key_here';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Collaborative Shopping List',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/auth', // Start with auth screen
      getPages: [
        GetPage(name: '/auth', page: () => const AuthScreen()),
        GetPage(name: '/shopping_list', page: () => const ShoppingListScreen()),
        GetPage(name: '/payment', page: () => const PaymentScreen()),
      ],
    );
  }
}