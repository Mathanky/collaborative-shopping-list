import 'package:get/get.dart';

// Simple mock User class
class MockUser {
  final String uid = 'mockUid';
  final String email = 'test@example.com'; // Default for demo
}

class AuthController extends GetxController {
  final Rx<MockUser?> user = Rx<MockUser?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = null;
    print('Controller init, user: ${user.value?.uid ?? "null"}');
  }

  Future<void> login(String email, String password) async {
    print('Login attempt: $email');
    if (email == 'test@example.com' && password == 'password123') {
      user.value = MockUser();
      print('Login success, user: ${user.value?.uid}');
      Get.snackbar('Success', 'Logged in as ${user.value?.email}');
      Get.offAllNamed('/shopping_list'); // Use route name
    } else {
      print('Login error: Invalid credentials');
      Get.snackbar('Error', 'Invalid email or password');
    }
  }

  Future<void> signUp(String email, String password) async {
    user.value = MockUser();
    print('Signup success for $email');
    Get.snackbar('Success', 'Account created for $email');
    Get.offAllNamed('/shopping_list'); // Use route name
  }

  Future<void> logout() async {
    user.value = null;
    print('Logout success');
    Get.snackbar('Success', 'Logged out');
    Get.offAllNamed('/auth'); // Back to auth screen
  }
}