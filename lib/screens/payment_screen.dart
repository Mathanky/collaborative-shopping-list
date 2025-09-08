import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;

  Future<void> initPaymentSheet() async {
    try {
      setState(() {
        isLoading = true;
      });

      // 1. Create payment intent on your server
      final response = await http.post(
        Uri.parse('https://your-backend-server.com/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': 1000, // Amount in cents (e.g., $10.00)
          'currency': 'usd',
        }),
      );

      final jsonResponse = jsonDecode(response.body);

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['clientSecret'],
          merchantDisplayName: 'Collaborative Shopping List',
        ),
      );

      // 3. Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Payment'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: initPaymentSheet,
                child: const Text('Pay \$10.00'), // Escaped dollar sign
              ),
      ),
    );
  }
}