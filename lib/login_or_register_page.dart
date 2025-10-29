import 'package:flutter/material.dart';
import 'package:ui_test/login_screen.dart';
import 'package:ui_test/register_screen.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage ? LoginScreen(showRegisterScreen: togglePages) : RegisterScreen(showLoginScreen: togglePages);
  }
}