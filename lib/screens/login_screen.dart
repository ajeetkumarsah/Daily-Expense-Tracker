import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/repositories/auth_repository.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:expense_tracker/screens/register_screen.dart';
import 'package:expense_tracker/utils/png_files.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              PngFiles.icon,
              height: 90,
            ),
            TextField(
              controller: usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authRepository.loginUser(
                  usernameController.text,
                  passwordController.text,
                );
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashboardScreen(userId: user.id ?? 0),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid credentials')));
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                text: "Don't have an account? ", // Regular text
                style: GoogleFonts.ptSansCaption(
                    color: Colors.black), // Style for the regular text
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: GoogleFonts.ptSansCaption(
                      color: Colors.deepPurple, // Link color
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterScreen(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
