import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/firebase_service.dart';
import '../../models/user_model.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroCtrl;
  late AnimationController _floatCtrl;
  late Animation<double> _heroFade;
  late Animation<double> _heroSlide;
  late Animation<double> _floatAnim;

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);

    _heroFade =
        CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<double>(begin: 30, end: 0).animate(
        CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _heroCtrl.forward();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _floatCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHero(context),
          _buildStatsStrip(context),
          _buildCategories(context),
          _buildHowItWorks(context),
          _buildTrendingEquipment(context),
          _buildWhyGearNest(context),
          _buildTestimonials(context),
          _buildVendorCTA(context),
        ],
      ),
    );
  }

  // ─── HERO ──────────────────────────────────────────────────────────────────
  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 600),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B1120),
            Color(0xFF0F172A),
            Color(0xFF0C1A2E),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background mesh pattern
          Positioned.fill(
            child: CustomPaint(painter: _MeshPainter()),
          ),

          // Glowing orbs
          Positioned(
            right: -80,
            top: -80,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF06B6D4).withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -60,
            bottom: -60,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppColors.webBodyMaxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 64, vertical: 100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left — Text + Search
                    Expanded(
                      flex: 5,
                      child: FadeTransition(
                        opacity: _heroFade,
                        child: AnimatedBuilder(
                          animation: _heroSlide,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(0, _heroSlide.value),
                            child: child,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0x1506B6D4),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: const Color(0x4006B6D4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.bolt_rounded,
                                        color: AppColors.accent, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Premium Event Gear Rental',
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.accent),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Headline
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w900,
                                    height: 1.05,
                                    letterSpacing: -2,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(text: 'Rent Gear,\n'),
                                    TextSpan(
                                      text: 'Create Magic.',
                                      style: TextStyle(
                                        foreground: Paint()
                                          ..shader = LinearGradient(
                                            colors: [
                                              Color(0xFF06B6D4),
                                              Color(0xFF6366F1),
                                            ],
                                          ).createShader(
                                              Rect.fromLTWH(0, 0, 400, 80)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              Text(
                                'Find and book premium event equipment from\ntrusted vendors — tents, AV, lighting & more.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  color: const Color(0xFF94A3B8),
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Search bar
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFF334155)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color(0x3306B6D4),
                                        blurRadius: 32,
                                        offset: Offset(0, 8)),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 20),
                                    const Icon(Icons.search_rounded,
                                        color: Color(0xFF64748B), size: 22),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchCtrl,
                                        style: GoogleFonts.plusJakartaSans(
                                            color: Colors.white, fontSize: 15),
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search tents, speakers, lights…',
                                          hintStyle:
                                              GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF475569),
                                            fontSize: 15,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          filled: false,
                                        ),
                                        onSubmitted: (_) =>
                                            context.go('/categories'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.go('/categories'),
                                      child: Container(
                                        margin: const EdgeInsets.all(6),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient:
                                              AppColors.accentGradient,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Search',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Trust pills
                              Wrap(
                                spacing: 12,
                                children: [
                                  _TrustPill(
                                      icon: Icons.verified_rounded,
                                      label: 'Verified Vendors'),
                                  _TrustPill(
                                      icon: Icons.security_rounded,
                                      label: 'Secure Payments'),
                                  _TrustPill(
                                      icon: Icons.support_agent_rounded,
                                      label: '24/7 Support'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 80),

                    // Right — Floating gear graphic
                    Expanded(
                      flex: 4,
                      child: AnimatedBuilder(
                        animation: _floatAnim,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _floatAnim.value),
                          child: child,
                        ),
                        child: _HeroGearGraphic(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STATS STRIP ────────────────────────────────────────────────────────────
  Widget _buildStatsStrip(BuildContext context) {
    final stats = [
      {'icon': Icons.inventory_2_rounded, 'value': '2,400+', 'label': 'Gear Items'},
      {'icon': Icons.storefront_rounded, 'value': '180+', 'label': 'Trusted Vendors'},
      {'icon': Icons.location_city_rounded, 'value': '40+', 'label': 'Cities Covered'},
      {'icon': Icons.emoji_events_rounded, 'value': '15K+', 'label': 'Events Powered'},
    ];

    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppColors.webBodyMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: stats.map((s) => _StatChip(
                icon: s['icon'] as IconData,
                value: s['value'] as String,
                label: s['label'] as String,
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ─── CATEGORIES ─────────────────────────────────────────────────────────────
  Widget _buildCategories(BuildContext context) {
    final cats = [
      {
        'name': 'Tents & Marquees',
        'icon': '⛺',
        'count': '240 items',
        'gradient': [const Color(0xFF0F172A), const Color(0xFF1E3A5F)],
        'image': 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=600&q=80',
      },
      {
        'name': 'Sound & AV',
        'icon': '🔊',
        'count': '180 items',
        'gradient': [const Color(0xFF0F172A), const Color(0xFF1A1F3A)],
        'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80',
      },
      {
        'name': 'Lighting',
        'icon': '💡',
        'count': '320 items',
        'gradient': [const Color(0xFF0F172A), const Color(0xFF1F2937)],
        'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=80',
      },
      {
        'name': 'Staging & Flooring',
        'icon': '🎭',
        'count': '90 items',
        'gradient': [const Color(0xFF0F172A), const Color(0xFF1E293B)],
        'image': 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600&q=80',
      },
      {
        'name': 'Décor & Floral',
        'icon': '🌸',
        'count': '410 items',
        'gradient': [const Color(0xFF0F172A), const Color(0xFF3B1F2B)],
        'image': 'https://images.unsplash.com/photo-1519741497674-611481863552?w=600&q=80',
      },
      {
        'name': 'Catering Gear',
        'icon': '🍽️',
        'count': '150 items',
        'gradient': [const Color(0xFF0F172A), const Color(0xFF1A2A1A)],
        'image': 'https://images.unsplash.com/photo-1555244162-803834f70033?w=600&q=80',
      },
    ];

    return _WebSection(
      bg: AppColors.background,
      child: Column(
        children: [
          _SectionHeader(
            badge: 'What We Offer',
            title: 'Browse by Category',
            subtitle:
                'Discover thousands of premium items across every event need',
          ),
          const SizedBox(height: 40),
          LayoutBuilder(builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 900 ? 3 : 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.5,
              ),
              itemCount: cats.length,
              itemBuilder: (_, i) => _CategoryCard(cat: cats[i]),
            );
          }),
        ],
      ),
    );
  }

  // ─── HOW IT WORKS ───────────────────────────────────────────────────────────
  Widget _buildHowItWorks(BuildContext context) {
    final steps = [
      {
        'step': '01',
        'icon': Icons.search_rounded,
        'title': 'Browse & Select',
        'desc': 'Search thousands of items from verified vendors near you.',
      },
      {
        'step': '02',
        'icon': Icons.calendar_today_rounded,
        'title': 'Book Your Dates',
        'desc': 'Choose availability, quantity, and confirm your booking.',
      },
      {
        'step': '03',
        'icon': Icons.local_shipping_rounded,
        'title': 'Delivered to You',
        'desc': 'Gear arrives at your venue on time, every time.',
      },
    ];

    return _WebSection(
      bg: const Color(0xFF0F172A),
      child: Column(
        children: [
          _SectionHeader(
            badge: 'Simple Process',
            title: 'How GearNest Works',
            subtitle: 'Get from browsing to event-ready in minutes',
            dark: true,
          ),
          const SizedBox(height: 56),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps.asMap().entries.map((e) {
              final i = e.key;
              final step = e.value;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(child: _HowItWorksCard(step: step)),
                    if (i < steps.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.arrow_forward_rounded,
                            color: AppColors.accent.withValues(alpha: 0.4),
                            size: 28),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── TRENDING ───────────────────────────────────────────────────────────────
  Widget _buildTrendingEquipment(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: FirebaseService().userProfileStream(),
      builder: (context, _) {
        final items = [
          {
            'id': '1',
            'name': 'Professional PA System 5000W',
            'price': '₹1,500',
            'unit': '/day',
            'rating': 4.8,
            'reviews': 124,
            'badge': 'Top Pick',
            'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
          },
          {
            'id': '2',
            'name': 'LED Stage Lighting Kit',
            'price': '₹2,000',
            'unit': '/day',
            'rating': 4.9,
            'reviews': 89,
            'badge': 'Popular',
            'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&q=80',
          },
          {
            'id': '3',
            'name': 'Portable Stage Platform',
            'price': '₹3,000',
            'unit': '/day',
            'rating': 4.7,
            'reviews': 56,
            'badge': null,
            'image': 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=400&q=80',
          },
          {
            'id': '4',
            'name': 'Wireless Microphone Set',
            'price': '₹800',
            'unit': '/day',
            'rating': 4.6,
            'reviews': 201,
            'badge': 'Best Value',
            'image': 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=400&q=80',
          },
        ];

        return _WebSection(
          bg: AppColors.background,
          child: Column(
            children: [
              _SectionHeader(
                badge: 'Trending Now',
                title: 'Most Booked Equipment',
                subtitle: 'Hand-picked by our team based on event success',
              ),
              const SizedBox(height: 40),
              LayoutBuilder(builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 900 ? 4 : 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _EquipmentCard(item: items[i]),
                );
              }),
              const SizedBox(height: 40),
              _WebOutlineButton(
                label: 'View All Equipment',
                onTap: () => context.go('/categories'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── WHY GEARNEST ───────────────────────────────────────────────────────────
  Widget _buildWhyGearNest(BuildContext context) {
    final features = [
      {
        'icon': Icons.verified_user_rounded,
        'title': 'Verified Vendors Only',
        'desc': 'Every vendor is screened, verified, and rated by real customers.',
      },
      {
        'icon': Icons.price_check_rounded,
        'title': 'Best Price Guarantee',
        'desc': 'We match any lower price from a verified competitor.',
      },
      {
        'icon': Icons.support_agent_rounded,
        'title': '24/7 Concierge Support',
        'desc': 'Live chat, phone & email support whenever you need it.',
      },
      {
        'icon': Icons.local_shipping_rounded,
        'title': 'On-Time Delivery',
        'desc': 'GPS-tracked deliveries with real-time status updates.',
      },
      {
        'icon': Icons.lock_rounded,
        'title': 'Secure Payments',
        'desc': 'PCI-compliant checkout with escrow protection.',
      },
      {
        'icon': Icons.autorenew_rounded,
        'title': 'Hassle-Free Returns',
        'desc': 'Pickup & return handled directly by the vendor.',
      },
    ];

    return _WebSection(
      bg: const Color(0xFF0B1120),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left — graphic
          Expanded(
            flex: 4,
            child: Container(
              height: 440,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0E7490), Color(0xFF4F46E5)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomPaint(painter: _GridPainter()),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.hub_rounded,
                            color: Colors.white, size: 80),
                        const SizedBox(height: 16),
                        Text(
                          'GearNest',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Event. Our Gear.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 80),
          // Right — features
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  badge: 'Why Choose Us',
                  title: 'Built for Event Pros',
                  subtitle:
                      'Everything you need to execute flawless events, every time.',
                  dark: true,
                  alignLeft: true,
                ),
                const SizedBox(height: 32),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: features.length,
                  itemBuilder: (_, i) => _FeatureTile(feat: features[i]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── TESTIMONIALS ───────────────────────────────────────────────────────────
  Widget _buildTestimonials(BuildContext context) {
    final reviews = [
      {
        'name': 'Priya Sharma',
        'role': 'Wedding Planner',
        'text':
            'GearNest made sourcing equipment for a 500-guest wedding effortless. The vendors were prompt and professional.',
        'rating': 5,
        'avatar': '👩‍💼',
      },
      {
        'name': 'Rahul Mehta',
        'role': 'Event Organizer',
        'text':
            'I rented a full lighting rig for a corporate gala. Everything arrived on time and the quality was outstanding.',
        'rating': 5,
        'avatar': '👨‍💻',
      },
      {
        'name': 'Aisha Khan',
        'role': 'Concert Producer',
        'text':
            'The PA system I booked sounded incredible. GearNest\'s vendor verification process is top-notch.',
        'rating': 5,
        'avatar': '👩‍🎤',
      },
    ];

    return _WebSection(
      bg: AppColors.background,
      child: Column(
        children: [
          _SectionHeader(
            badge: 'Loved by Thousands',
            title: 'What Our Customers Say',
            subtitle: 'Trusted by event planners, producers, and vendors nationwide',
          ),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: reviews
                .map((r) => Expanded(child: _TestimonialCard(review: r)))
                .expand((w) => [
                      w,
                      const SizedBox(width: 24),
                    ])
                .toList()
              ..removeLast(),
          ),
        ],
      ),
    );
  }

  // ─── VENDOR CTA ─────────────────────────────────────────────────────────────
  Widget _buildVendorCTA(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E7490), Color(0xFF4338CA)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              const Icon(Icons.storefront_rounded,
                  color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                'List Your Gear on GearNest',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Join 180+ vendors earning from their idle equipment.\nNo setup fee, no monthly charges.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x4400000),
                                blurRadius: 24,
                                offset: Offset(0, 8)),
                          ],
                        ),
                        child: Text(
                          'Start Listing Free',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0E7490),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'Learn More',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _WebSection extends StatelessWidget {
  final Widget child;
  final Color bg;
  const _WebSection({required this.child, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppColors.webBodyMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;
  final bool dark;
  final bool alignLeft;

  const _SectionHeader({
    required this.badge,
    required this.title,
    required this.subtitle,
    this.dark = false,
    this.alignLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    final align =
        alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    final textAlign = alignLeft ? TextAlign.left : TextAlign.center;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0x1506B6D4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0x4006B6D4)),
          ),
          child: Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: textAlign,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: dark ? Colors.white : AppColors.textPrimary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: textAlign,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: dark
                ? const Color(0xFF94A3B8)
                : AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _TrustPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatChip(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0x1506B6D4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accent, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, dynamic> cat;
  const _CategoryCard({required this.cat});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/categories'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.03 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x0F0F172A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.cat['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0F172A).withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cat['icon'] as String,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.cat['name'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.cat['count'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_hovered)
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Explore →',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  final Map<String, dynamic> step;
  const _HowItWorksCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(step['icon'] as IconData,
                    color: Colors.white, size: 24),
              ),
              const Spacer(),
              Text(
                step['step'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: const Color(0x1206B6D4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            step['title'] as String,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step['desc'] as String,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF94A3B8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const _EquipmentCard({required this.item});

  @override
  State<_EquipmentCard> createState() => _EquipmentCardState();
}

class _EquipmentCardState extends State<_EquipmentCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/equipment-detail/${widget.item['id']}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.3)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                      child: Image.network(
                        widget.item['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.surfaceSubtle),
                      ),
                    ),
                    if (widget.item['badge'] != null)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            widget.item['badge'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (_hovered)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradient,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                'View Details',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item['name'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.item['rating']}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${widget.item['reviews']})',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            widget.item['price'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.accent,
                            ),
                          ),
                          Text(
                            widget.item['unit'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final Map<String, dynamic> feat;
  const _FeatureTile({required this.feat});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x1506B6D4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(feat['icon'] as IconData,
              color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                feat['title'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                feat['desc'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _TestimonialCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              review['rating'] as int,
              (_) => const Icon(Icons.star_rounded,
                  color: Color(0xFFF59E0B), size: 16),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"${review['text']}"',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review['avatar'] as String,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['name'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    review['role'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebOutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _WebOutlineButton({required this.label, required this.onTap});

  @override
  State<_WebOutlineButton> createState() => _WebOutlineButtonState();
}

class _WebOutlineButtonState extends State<_WebOutlineButton> {
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
          padding:
              const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _hovered ? AppColors.accent : const Color(0xFFCBD5E1),
              width: 1.5,
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color:
                  _hovered ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroGearGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main central card
          Container(
            width: 320,
            height: 380,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4406B6D4),
                  blurRadius: 48,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.hub_rounded,
                      color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  'GearNest',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium Gear Rentals',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 32),
                _GearStat('2,400+', 'Items'),
                const SizedBox(height: 12),
                _GearStat('180+', 'Vendors'),
                const SizedBox(height: 12),
                _GearStat('4.9★', 'Rating'),
              ],
            ),
          ),

          // Floating mini cards
          Positioned(
            top: 20,
            right: 0,
            child: _FloatingMiniCard(
              icon: Icons.mic_rounded,
              label: 'Microphones',
              color: const Color(0xFF06B6D4),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            child: _FloatingMiniCard(
              icon: Icons.lightbulb_rounded,
              label: 'Lighting',
              color: const Color(0xFF6366F1),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 0,
            child: _FloatingMiniCard(
              icon: Icons.speaker_rounded,
              label: 'Audio',
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}

class _GearStat extends StatelessWidget {
  final String value;
  final String label;
  const _GearStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _FloatingMiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _FloatingMiniCard(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Custom Painters ──────────────────────────────────────────────────────────

class _MeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x06FFFFFF)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
