import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/repositories/auth_repository.dart';
import 'package:expense_tracker/utils/png_files.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Register",
        style: GoogleFonts.ptSansCaption(color: Colors.black),
      )),
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
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
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
                try {
                  await _authRepository.registerUser(
                    User(
                      email: emailController.text,
                      username: usernameController.text,
                      password: passwordController.text,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('User Registered Successfully')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')));
                }
              },
              child: Text(
                'Register',
                style: GoogleFonts.ptSansCaption(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
