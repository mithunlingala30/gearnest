import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/firebase_service.dart';
import 'web_shared.dart';

class WebSignupScreen extends StatefulWidget {
  const WebSignupScreen({super.key});

  @override
  State<WebSignupScreen> createState() => _WebSignupScreenState();
}

class _WebSignupScreenState extends State<WebSignupScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscure = true;
  String _role = 'Customer';
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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await FirebaseService().signUp(
        _emailCtrl.text.trim(),
        _passCtrl.text,
        _nameCtrl.text.trim(),
        _role,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _error = 'Registration failed. Please try again.');
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
                      Color(0xFF1A0B2E),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: CustomPaint(painter: WebMeshPainter())),
                    Positioned(
                      right: -80,
                      top: -80,
                      child: Container(
                        width: 450,
                        height: 450,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFF6366F1).withValues(alpha: 0.15),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -60,
                      bottom: -60,
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFF06B6D4).withValues(alpha: 0.1),
                            Colors.transparent,
                          ]),
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
                            'Join the\nGearNest\nFamily.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.05,
                              letterSpacing: -2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Create an account and unlock access\nto thousands of premium event gear.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: const Color(0xFF64748B),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Role cards
                          Row(
                            children: [
                              _RoleCard(
                                icon: Icons.person_rounded,
                                title: 'Customer',
                                desc: 'Rent gear for your events',
                                selected: _role == 'Customer',
                                onTap: () => setState(() => _role = 'Customer'),
                              ),
                              const SizedBox(width: 16),
                              _RoleCard(
                                icon: Icons.storefront_rounded,
                                title: 'Vendor',
                                desc: 'List & rent out your gear',
                                selected: _role == 'Vendor',
                                onTap: () => setState(() => _role = 'Vendor'),
                              ),
                            ],
                          ),
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Create Account',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Fill in your details to get started',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 28),

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
                                      child: Text(_error!,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            color: AppColors.danger,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Role toggle
                            _CompactRoleToggle(
                              role: _role,
                              onChanged: (r) => setState(() => _role = r),
                            ),
                            const SizedBox(height: 20),

                            WebFormField(
                              label: 'Full Name',
                              hint: 'John Doe',
                              controller: _nameCtrl,
                              icon: Icons.person_outline_rounded,
                              validator: (v) => (v?.isEmpty ?? true)
                                  ? 'Name is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),

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
                              hint: 'Min. 8 characters',
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
                              validator: (v) => (v?.length ?? 0) < 6
                                  ? 'Min. 6 characters'
                                  : null,
                            ),

                            const SizedBox(height: 28),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: GestureDetector(
                                onTap: _loading ? null : _signup,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6366F1),
                                          Color(0xFF06B6D4),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0x336366F1),
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
                                              'Create Account',
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

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: AppColors.textSecondary),
                                ),
                                GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: Text(
                                    'Sign in',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                'By creating an account you agree to our\nTerms of Service and Privacy Policy.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: const Color(0xFF94A3B8),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
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

// ─── Local-only sub-widgets ───────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0x1506B6D4)
                : const Color(0x0FFFFFFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.accent : const Color(0x2FFFFFFF),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? AppColors.accent : const Color(0xFF64748B),
                  size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.accent : Colors.white,
                ),
              ),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactRoleToggle extends StatelessWidget {
  final String role;
  final ValueChanged<String> onChanged;
  const _CompactRoleToggle({required this.role, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ['Customer', 'Vendor'].map((r) {
          final selected = role == r;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: selected
                      ? [
                          const BoxShadow(
                              color: Color(0x1F0F172A),
                              blurRadius: 8,
                              offset: Offset(0, 2))
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    r,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
