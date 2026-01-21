import 'package:casetracking/core/routes/routes.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/core/services/token_service.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Small delay for splash feel
    await Future.delayed(const Duration(milliseconds: 800));

    final token = TokenServices().accessToken;
    final loggedIn = await LocalDb.isLoggedIn();

    if (!mounted) return;

    if (token != null && token.isNotEmpty && loggedIn) {
      // ✅ User already logged in
      router.goNamed(Routes.home.name);
    } else {
      // ❌ No session
      router.goNamed(Routes.login.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
