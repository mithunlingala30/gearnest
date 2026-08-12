import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.go('/home');
      } else {
        context.go('/onboarding-1');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('GearNest',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  Text(
                    'Rent Premium Event Gear & Logistics',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
