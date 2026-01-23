import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/presentation/pages/login_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/register_page.dart';

class AuthPages extends StatefulWidget {
  const AuthPages({super.key});

  @override
  State<AuthPages> createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPages> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(toggle: togglePages);
    }
  }
}
