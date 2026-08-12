import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

/// Top-level shell for the web layout.
/// Renders a sticky [_WebTopNav], the page [child], and a [_WebFooter].
class WebShell extends StatelessWidget {
  final Widget child;
  const WebShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _WebTopNav(),
          Expanded(child: child),
          const _WebFooter(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP NAVIGATION BAR
// ─────────────────────────────────────────────────────────────────────────────

class _WebTopNav extends StatefulWidget {
  @override
  State<_WebTopNav> createState() => _WebTopNavState();
}

class _WebTopNavState extends State<_WebTopNav> {
  String? _hoveredLink;

  static const _navLinks = [
    {'label': 'Home', 'route': '/home'},
    {'label': 'Browse', 'route': '/categories'},
    {'label': 'Vendors', 'route': '/categories'},
    {'label': 'How It Works', 'route': '/home'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Container(
      height: AppColors.webNavHeight,
      decoration: const BoxDecoration(
        color: AppColors.webNavBg,
        boxShadow: [
          BoxShadow(
            color: Color(0x3306B6D4),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppColors.webBodyMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                // ── Logo ────────────────────────────────────────────────────
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF06B6D4), Color(0xFF6366F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.hub_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'GearNest',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 48),

                // ── Nav Links ───────────────────────────────────────────────
                Expanded(
                  child: Row(
                    children: _navLinks.map((link) {
                      final label = link['label']!;
                      final route = link['route']!;
                      final isActive = currentPath == route;
                      final isHovered = _hoveredLink == label;

                      return MouseRegion(
                        onEnter: (_) => setState(() => _hoveredLink = label),
                        onExit: (_) => setState(() => _hoveredLink = null),
                        child: GestureDetector(
                          onTap: () => context.go(route),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive || isHovered
                                  ? AppColors.webHoverCyan
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              label,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isActive
                                    ? AppColors.accent
                                    : (isHovered
                                        ? Colors.white
                                        : const Color(0xFF94A3B8)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // ── Right Actions ───────────────────────────────────────────
                StreamBuilder<UserModel?>(
                  stream: FirebaseService().userProfileStream(),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    if (user != null) {
                      return Row(
                        children: [
                          _NavIconButton(
                            icon: Icons.notifications_none_rounded,
                            onTap: () => context.go('/notifications'),
                          ),
                          const SizedBox(width: 8),
                          _NavIconButton(
                            icon: Icons.shopping_cart_outlined,
                            onTap: () => context.go('/cart'),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => context.go('/profile'),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.accentGradient,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person_rounded,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      user.name.split(' ').first,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    // Guest state
                    return Row(
                      children: [
                        _NavTextButton(
                          label: 'Sign In',
                          onTap: () => context.go('/login'),
                        ),
                        const SizedBox(width: 8),
                        _NavCTAButton(
                          label: 'Get Started',
                          onTap: () => context.go('/signup'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper nav widgets ────────────────────────────────────────────────────────

class _NavIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavIconButton({required this.icon, required this.onTap});

  @override
  State<_NavIconButton> createState() => _NavIconButtonState();
}

class _NavIconButtonState extends State<_NavIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0x2006B6D4)
                : const Color(0x0FFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(widget.icon,
              color: _hovered ? AppColors.accent : const Color(0xFF94A3B8),
              size: 20),
        ),
      ),
    );
  }
}

class _NavTextButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavTextButton({required this.label, required this.onTap});

  @override
  State<_NavTextButton> createState() => _NavTextButtonState();
}

class _NavTextButtonState extends State<_NavTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _hovered ? Colors.white : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavCTAButton({required this.label, required this.onTap});

  @override
  State<_NavCTAButton> createState() => _NavCTAButtonState();
}

class _NavCTAButtonState extends State<_NavCTAButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered
                  ? [const Color(0xFF0284C7), const Color(0xFF4F46E5)]
                  : [const Color(0xFF06B6D4), const Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: _hovered
                ? [
                    const BoxShadow(
                        color: Color(0x4006B6D4),
                        blurRadius: 16,
                        offset: Offset(0, 4))
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────────────────────────

class _WebFooter extends StatelessWidget {
  const _WebFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B1120),
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppColors.webBodyMaxWidth),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand column
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF06B6D4),
                                    Color(0xFF6366F1)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.hub_rounded,
                                  color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'GearNest',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'The premium marketplace for renting\nevent gear from trusted vendors.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: const Color(0xFF64748B),
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _SocialIcon(Icons.facebook_rounded),
                            const SizedBox(width: 12),
                            _SocialIcon(Icons.camera_alt_outlined),
                            const SizedBox(width: 12),
                            _SocialIcon(Icons.telegram_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 48),

                  // Footer columns
                  _FooterColumn(
                    title: 'Product',
                    links: [
                      'Browse Equipment',
                      'Vendor Dashboard',
                      'Pricing',
                      'FAQ',
                    ],
                  ),
                  const SizedBox(width: 48),
                  _FooterColumn(
                    title: 'Company',
                    links: ['About Us', 'Careers', 'Blog', 'Press'],
                  ),
                  const SizedBox(width: 48),
                  _FooterColumn(
                    title: 'Support',
                    links: ['Help Center', 'Contact Us', 'Community', 'Status'],
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Bottom bar
              Container(
                height: 1,
                color: const Color(0xFF1E293B),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© 2026 GearNest. All rights reserved.',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 13, color: const Color(0xFF475569)),
                  ),
                  Row(
                    children: [
                      Text('Privacy Policy',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13, color: const Color(0xFF475569))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('·',
                            style: TextStyle(color: Color(0xFF475569))),
                      ),
                      Text('Terms of Service',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13, color: const Color(0xFF475569))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        const SizedBox(height: 16),
        ...links.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  l,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, color: const Color(0xFF64748B)),
                ),
              ),
            )),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0x2006B6D4)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.5)
                : const Color(0xFF334155),
          ),
        ),
        child: Icon(widget.icon,
            size: 18,
            color: _hovered ? AppColors.accent : const Color(0xFF64748B)),
      ),
    );
  }
}
