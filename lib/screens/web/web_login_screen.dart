import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/firebase_service.dart';
import 'web_shared.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await FirebaseService().signIn(_emailCtrl.text.trim(), _passCtrl.text);
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _error = 'Invalid email or password. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Row(
          children: [
            // ── Left brand panel ─────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0B1120),
                      Color(0xFF0F172A),
                      Color(0xFF0C2340),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: CustomPaint(painter: WebMeshPainter())),
                    Positioned(
                      left: -100,
                      top: -100,
                      child: Container(
                        width: 500,
                        height: 500,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF06B6D4).withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -80,
                      bottom: -80,
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF6366F1).withValues(alpha: 0.12),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(64),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => context.go('/home'),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.hub_rounded,
                                      color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'GearNest',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Welcome\nBack.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                              letterSpacing: -2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sign in to manage bookings, browse\npremium gear, and track your orders.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: const Color(0xFF64748B),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 48),
                          ...[
                            'Access 2,400+ verified items',
                            'Real-time order tracking',
                            'Secure escrow payments',
                          ].map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.accentGradient,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 14),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      f,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        color: const Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Right form panel ─────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 64, vertical: 48),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sign In',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Enter your credentials to continue',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 36),

                          if (_error != null) ...[
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFFCA5A5)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded,
                                      color: AppColors.danger, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _error!,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: AppColors.danger,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          WebFormField(
                            label: 'Email Address',
                            hint: 'you@example.com',
                            controller: _emailCtrl,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v?.isEmpty ?? true)
                                ? 'Email is required'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          WebFormField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: _passCtrl,
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscure,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF94A3B8),
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) => (v?.isEmpty ?? true)
                                ? 'Password is required'
                                : null,
                          ),

                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => context.go('/forgot-password'),
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: GestureDetector(
                              onTap: _loading ? null : _login,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color(0x3306B6D4),
                                          blurRadius: 20,
                                          offset: Offset(0, 6)),
                                    ],
                                  ),
                                  child: Center(
                                    child: _loading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Sign In',
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.go('/signup'),
                                child: Text(
                                  'Sign up free',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
