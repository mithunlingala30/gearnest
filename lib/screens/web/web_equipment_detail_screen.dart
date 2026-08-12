import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/cart_service.dart';
import '../../services/firebase_service.dart';

class WebEquipmentDetailScreen extends StatefulWidget {
  final String id;
  const WebEquipmentDetailScreen({super.key, required this.id});

  @override
  State<WebEquipmentDetailScreen> createState() =>
      _WebEquipmentDetailScreenState();
}

class _WebEquipmentDetailScreenState extends State<WebEquipmentDetailScreen> {
  int _quantity = 1;
  int _days = 1;
  bool _isFav = false;
  int _selectedImg = 0;

  static final Map<String, Map<String, dynamic>> _mockDetails = {
    '1': {
      'name': 'Professional PA System 5000W',
      'price': '₹1,500',
      'priceAmount': 1500.0,
      'category': 'Sound',
      'description':
          'High-power professional PA system delivering crystal-clear sound for concerts, weddings, and large-scale events. Includes 2x 15" subwoofers, amplifier, and all cabling.',
      'rating': 4.8,
      'reviews': 124,
      'vendorId': 'mock_vendor_1',
      'vendorName': 'AudioPro Rentals',
      'specs': {
        'Power': '5000W RMS',
        'Coverage': 'Up to 500 guests',
        'Includes': 'Subwoofers, Amplifier, Cables',
        'Setup': 'Vendor-assisted',
      },
    },
    '2': {
      'name': 'LED Stage Lighting Kit',
      'price': '₹2,000',
      'priceAmount': 2000.0,
      'category': 'Lighting',
      'description':
          'Complete LED stage lighting package with RGB wash lights, moving heads, and DMX controller. Perfect for concerts, gala dinners, and fashion shows.',
      'rating': 4.9,
      'reviews': 89,
      'vendorId': 'mock_vendor_2',
      'vendorName': 'LumiEvents',
      'specs': {
        'Fixtures': '12 LED wash lights + 4 moving heads',
        'Control': 'DMX 512',
        'Colors': '16.7 million RGB',
        'Setup': 'Professional crew included',
      },
    },
    '3': {
      'name': 'Portable Stage Platform',
      'price': '₹3,000',
      'priceAmount': 3000.0,
      'category': 'Staging',
      'description':
          'Sturdy modular staging system available in multiple configurations. Ideal for performances, speeches, and product launches.',
      'rating': 4.7,
      'reviews': 56,
      'vendorId': 'mock_vendor_3',
      'vendorName': 'StageMasters',
      'specs': {
        'Size': '4m × 6m standard (customizable)',
        'Height': '0.6m / 1.0m / 1.2m',
        'Load': '750 kg/m²',
        'Delivery': 'Included',
      },
    },
  };

  static final Map<String, List<String>> _images = {
    '1': [
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=800&q=80',
      'https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?w=800&q=80',
    ],
    '2': [
      'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&q=80',
      'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800&q=80',
    ],
    '3': [
      'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800&q=80',
      'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&q=80',
      'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&q=80',
    ],
  };

  Map<String, dynamic> get _item =>
      _mockDetails[widget.id] ?? _mockDetails['1']!;
  List<String> get _itemImages =>
      _images[widget.id] ?? _images['1']!;

  double get _totalPrice =>
      (_item['priceAmount'] as double) * _quantity * _days;

  void _addToCart() {
    CartService().addItem(CartItem(
      id: widget.id,
      name: _item['name'] as String,
      price: (_item['priceAmount'] as double),
      qty: _quantity,
      days: _days,
      emoji: '🎪',
      vendorId: _item['vendorId'] as String,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart!',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppColors.webBodyMaxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Breadcrumb ──────────────────────────────────────────────
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Text('Home',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.chevron_right_rounded,
                            size: 16, color: Color(0xFF94A3B8)),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/categories'),
                        child: Text('Browse',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.chevron_right_rounded,
                            size: 16, color: Color(0xFF94A3B8)),
                      ),
                      Expanded(
                        child: Text(
                          _item['name'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── 2-Column layout ─────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Left: Image gallery ────────────────────────────────
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            // Main image
                            Container(
                              height: 420,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppColors.softShadow,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  _itemImages[_selectedImg],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.surfaceSubtle,
                                    child: const Icon(Icons.image_outlined,
                                        size: 64, color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Thumbnail strip
                            Row(
                              children: _itemImages
                                  .asMap()
                                  .entries
                                  .map((e) => GestureDetector(
                                        onTap: () => setState(
                                            () => _selectedImg = e.key),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 150),
                                          margin: const EdgeInsets.only(
                                              right: 10),
                                          width: 88,
                                          height: 66,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _selectedImg == e.key
                                                  ? AppColors.accent
                                                  : const Color(0xFFE2E8F0),
                                              width: 2,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              e.value,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                      color: AppColors
                                                          .surfaceSubtle),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),

                            const SizedBox(height: 32),

                            // Description
                            _DetailCard(
                              title: 'About This Item',
                              child: Text(
                                _item['description'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                  height: 1.7,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Specs
                            _DetailCard(
                              title: 'Specifications',
                              child: Column(
                                children:
                                    (_item['specs'] as Map<String, String>)
                                        .entries
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      bottom: 12),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text(
                                                      e.key,
                                                      style: GoogleFonts
                                                          .plusJakartaSans(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      e.value,
                                                      style: GoogleFonts
                                                          .plusJakartaSans(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Reviews
                            _DetailCard(
                              title: 'Customer Reviews',
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${_item['rating']}',
                                        style:
                                            GoogleFonts.plusJakartaSans(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: List.generate(
                                              5,
                                              (i) => Icon(
                                                Icons.star_rounded,
                                                color: i <
                                                        ((_item['rating']
                                                                as double)
                                                            .round())
                                                    ? const Color(
                                                        0xFFF59E0B)
                                                    : const Color(
                                                        0xFFE2E8F0),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_item['reviews']} reviews',
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              color:
                                                  AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ..._sampleReviews
                                      .map((r) => _ReviewTile(review: r)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 32),

                      // ── Right: Sticky booking panel ────────────────────────
                      SizedBox(
                        width: 340,
                        child: _StickyBookingPanel(
                          item: _item,
                          quantity: _quantity,
                          days: _days,
                          isFav: _isFav,
                          totalPrice: _totalPrice,
                          onQuantityChanged: (q) =>
                              setState(() => _quantity = q),
                          onDaysChanged: (d) =>
                              setState(() => _days = d),
                          onFavToggle: () =>
                              setState(() => _isFav = !_isFav),
                          onAddToCart: _addToCart,
                          onBook: () => context.go('/checkout'),
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
    );
  }
}

// ─── Sticky Booking Panel ─────────────────────────────────────────────────────

class _StickyBookingPanel extends StatelessWidget {
  final Map<String, dynamic> item;
  final int quantity;
  final int days;
  final bool isFav;
  final double totalPrice;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<int> onDaysChanged;
  final VoidCallback onFavToggle;
  final VoidCallback onAddToCart;
  final VoidCallback onBook;

  const _StickyBookingPanel({
    required this.item,
    required this.quantity,
    required this.days,
    required this.isFav,
    required this.totalPrice,
    required this.onQuantityChanged,
    required this.onDaysChanged,
    required this.onFavToggle,
    required this.onAddToCart,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppColors.bubbleShadow,
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              item['category'] as String,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Name
          Text(
            item['name'] as String,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          // Rating
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  Icons.star_rounded,
                  color: i < ((item['rating'] as double).round())
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFFE2E8F0),
                  size: 16,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${item['rating']} (${item['reviews']} reviews)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['price'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  '/day',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 20),

          // Quantity
          _BookingRow(
            label: 'Quantity',
            child: _Stepper(
              value: quantity,
              min: 1,
              max: 20,
              onChanged: onQuantityChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Days
          _BookingRow(
            label: 'Days',
            child: _Stepper(
              value: days,
              min: 1,
              max: 30,
              onChanged: onDaysChanged,
            ),
          ),

          const SizedBox(height: 20),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹${totalPrice.toStringAsFixed(0)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$quantity item${quantity > 1 ? 's' : ''} × $days day${days > 1 ? 's' : ''}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Book now
          SizedBox(
            width: double.infinity,
            height: 52,
            child: GestureDetector(
              onTap: onBook,
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
                    child: Text(
                      'Book Now',
                      style: GoogleFonts.plusJakartaSans(
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
          const SizedBox(height: 12),

          // Add to cart
          SizedBox(
            width: double.infinity,
            height: 48,
            child: GestureDetector(
              onTap: onAddToCart,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_cart_outlined,
                            size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Vendor info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['vendorName'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Verified Vendor',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.verified_rounded,
                    color: AppColors.success, size: 20),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Features
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _FeaturePill(
                  icon: Icons.local_shipping_rounded, label: 'Free Delivery'),
              _FeaturePill(
                  icon: Icons.security_rounded, label: 'Secure Pay'),
              _FeaturePill(
                  icon: Icons.replay_rounded, label: 'Easy Returns'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingRow extends StatelessWidget {
  final String label;
  final Widget child;
  const _BookingRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        child,
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  const _Stepper(
      {required this.value,
      required this.min,
      required this.max,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepBtn(
          icon: Icons.remove_rounded,
          onTap: value > min ? () => onChanged(value - 1) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$value',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        _StepBtn(
          icon: Icons.add_rounded,
          onTap: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.accent.withValues(alpha: 0.1)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: onTap != null
                ? AppColors.accent.withValues(alpha: 0.3)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? AppColors.accent : const Color(0xFFCBD5E1),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _DetailCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review['name'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(
                        review['rating'] as int,
                        (_) => const Icon(Icons.star_rounded,
                            color: Color(0xFFF59E0B), size: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  review['text'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final _sampleReviews = [
  {
    'name': 'Ananya S.',
    'avatar': '👩',
    'rating': 5,
    'text': 'Absolutely phenomenal quality! The vendor was professional and setup was flawless.',
  },
  {
    'name': 'Karthik M.',
    'avatar': '👨',
    'rating': 5,
    'text': 'Rented for a corporate event. Exceeded our expectations in every way.',
  },
  {
    'name': 'Priya D.',
    'avatar': '👩‍🦱',
    'rating': 4,
    'text': 'Great product, smooth delivery. Would definitely rent again for the next event.',
  },
];
