import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:trackmate/pages/login_page.dart';
import 'package:trackmate/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // Initially show login page
  bool showLoginPage = true;
  bool isLoading = false;

  // Toggle between login and register page with a delay
  void togglePagesWithDelay() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      showLoginPage = !showLoginPage;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('lib/images/loading_animation.json'),
            Text(
              'Please wait...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    } else if (showLoginPage) {
      return LoginPage(
        onTap: togglePagesWithDelay,
      );
    } else {
      return RegisterPage(
        onTap: togglePagesWithDelay,
      );
    }
  }
}
