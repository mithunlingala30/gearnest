import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/firebase_service.dart';

// ── Real-world photo URLs by category/keyword ────────────────────────────
String _itemImageUrl(String name, String category) {
  final n = name.toLowerCase();
  final c = category.toLowerCase();
  if (n.contains('shamiyana') || n.contains('marquee') || n.contains('tent')) {
    return 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=600&q=80';
  }
  if (n.contains('floral') || n.contains('decor') || n.contains('flower') || n.contains('decoration')) {
    return 'https://images.unsplash.com/photo-1519741497674-611481863552?w=600&q=80';
  }
  if (n.contains('pa system') || n.contains('speaker') || n.contains('5000')) {
    return 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80';
  }
  if (n.contains('microphone') || n.contains('mic') || n.contains('wireless mic')) {
    return 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=600&q=80';
  }
  if (n.contains('dj') || n.contains('controller') || n.contains('mixing')) {
    return 'https://images.unsplash.com/photo-1571266028243-3716f02d2d2e?w=600&q=80';
  }
  if (n.contains('projector') || n.contains('4k') || n.contains('screen')) {
    return 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=600&q=80';
  }
  if (n.contains('led') || n.contains('stage light')) {
    return 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=80';
  }
  if (n.contains('chiavari') || n.contains('chair')) {
    return 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600&q=80';
  }
  if (n.contains('stage platform') || n.contains('portable stage')) {
    return 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600&q=80';
  }
  switch (c) {
    case 'tent': return 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=600&q=80';
    case 'decor': return 'https://images.unsplash.com/photo-1519741497674-611481863552?w=600&q=80';
    case 'sound': return 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80';
    case 'lighting': return 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=80';
    case 'staging': return 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600&q=80';
    case 'furniture': return 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600&q=80';
    default: return 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&q=80';
  }
}

class WebCategoriesScreen extends StatefulWidget {
  const WebCategoriesScreen({super.key});

  @override
  State<WebCategoriesScreen> createState() => _WebCategoriesScreenState();
}

class _WebCategoriesScreenState extends State<WebCategoriesScreen> {
  String _selectedCategory = 'All';
  double _maxPrice = 5000;
  double _minRating = 0;
  String _sortBy = 'Popular';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  final _categories = [
    'All', 'Tent', 'Sound', 'Lighting', 'Staging', 'Decor', 'Furniture',
  ];

  final _sortOptions = ['Popular', 'Price: Low–High', 'Price: High–Low', 'Rating'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppColors.webBodyMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Breadcrumb + heading ─────────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Text('Home',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.chevron_right_rounded,
                          size: 16, color: Color(0xFF94A3B8)),
                    ),
                    Text('Browse Equipment',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        )),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Search bar ───────────────────────────────────────────────
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search_rounded,
                          color: Color(0xFF94A3B8), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) =>
                              setState(() => _searchQuery = v.toLowerCase()),
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Search equipment, categories, vendors…',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            filled: false,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.close_rounded,
                                size: 18, color: Color(0xFF94A3B8)),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Main layout: sidebar + grid ──────────────────────────────
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Sidebar ──────────────────────────────────────────
                      SizedBox(
                        width: AppColors.webSidebarWidth,
                        child: _FilterSidebar(
                          categories: _categories,
                          selectedCategory: _selectedCategory,
                          maxPrice: _maxPrice,
                          minRating: _minRating,
                          onCategoryChanged: (c) =>
                              setState(() => _selectedCategory = c),
                          onMaxPriceChanged: (p) =>
                              setState(() => _maxPrice = p),
                          onMinRatingChanged: (r) =>
                              setState(() => _minRating = r),
                          onReset: () => setState(() {
                            _selectedCategory = 'All';
                            _maxPrice = 5000;
                            _minRating = 0;
                          }),
                        ),
                      ),

                      const SizedBox(width: 28),

                      // ── Product grid ──────────────────────────────────────
                      Expanded(
                        child: Column(
                          children: [
                            // Sort bar
                            Row(
                              children: [
                                Text(
                                  'Sort by:',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ..._sortOptions.map((s) => _SortChip(
                                      label: s,
                                      selected: _sortBy == s,
                                      onTap: () =>
                                          setState(() => _sortBy = s),
                                    )),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Grid
                            Expanded(
                              child: StreamBuilder<List<Map<String, dynamic>>>(
                                stream: FirebaseService()
                                    .streamEquipmentItems(),
                                builder: (context, snapshot) {
                                  var items = snapshot.data ?? _mockItems;

                                  // Filter
                                  if (_selectedCategory != 'All') {
                                    items = items
                                        .where((i) =>
                                            (i['category'] as String?)
                                                ?.toLowerCase() ==
                                            _selectedCategory.toLowerCase())
                                        .toList();
                                  }
                                  if (_searchQuery.isNotEmpty) {
                                    items = items
                                        .where((i) =>
                                            (i['name'] as String? ?? '')
                                                .toLowerCase()
                                                .contains(_searchQuery))
                                        .toList();
                                  }
                                  items = items
                                      .where((i) =>
                                          ((i['priceAmount'] as num?) ?? 0) <=
                                          _maxPrice)
                                      .toList();
                                  if (_minRating > 0) {
                                    items = items
                                        .where((i) =>
                                            ((i['rating'] as num?) ?? 0) >=
                                            _minRating)
                                        .toList();
                                  }

                                  // Sort
                                  if (_sortBy == 'Price: Low–High') {
                                    items.sort((a, b) => ((a['priceAmount'] as num?) ?? 0)
                                        .compareTo((b['priceAmount'] as num?) ?? 0));
                                  } else if (_sortBy == 'Price: High–Low') {
                                    items.sort((a, b) => ((b['priceAmount'] as num?) ?? 0)
                                        .compareTo((a['priceAmount'] as num?) ?? 0));
                                  } else if (_sortBy == 'Rating') {
                                    items.sort((a, b) => ((b['rating'] as num?) ?? 0)
                                        .compareTo((a['rating'] as num?) ?? 0));
                                  }

                                  if (items.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.search_off_rounded,
                                              size: 64,
                                              color: Color(0xFFCBD5E1)),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No equipment found',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Try adjusting your filters',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 0.72,
                                    ),
                                    itemCount: items.length,
                                    itemBuilder: (_, i) =>
                                        _WebProductCard(item: items[i]),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// ─── Filter Sidebar ──────────────────────────────────────────────────────────

class _FilterSidebar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final double maxPrice;
  final double minRating;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<double> onMaxPriceChanged;
  final ValueChanged<double> onMinRatingChanged;
  final VoidCallback onReset;

  const _FilterSidebar({
    required this.categories,
    required this.selectedCategory,
    required this.maxPrice,
    required this.minRating,
    required this.onCategoryChanged,
    required this.onMaxPriceChanged,
    required this.onMinRatingChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppColors.softShadow,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: onReset,
                  child: Text(
                    'Reset',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _FilterDivider(label: 'Category'),
            const SizedBox(height: 12),

            ...categories.map((cat) => _CategoryOption(
                  label: cat,
                  selected: selectedCategory == cat,
                  onTap: () => onCategoryChanged(cat),
                )),

            const SizedBox(height: 24),
            _FilterDivider(label: 'Max Price (₹/day)'),
            const SizedBox(height: 12),
            Text(
              '₹${maxPrice.toInt()}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.accent,
              ),
            ),
            Slider(
              value: maxPrice,
              min: 200,
              max: 10000,
              divisions: 98,
              activeColor: AppColors.accent,
              inactiveColor: const Color(0xFFE2E8F0),
              onChanged: onMaxPriceChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹200',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: const Color(0xFF94A3B8))),
                Text('₹10,000',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: const Color(0xFF94A3B8))),
              ],
            ),

            const SizedBox(height: 24),
            _FilterDivider(label: 'Minimum Rating'),
            const SizedBox(height: 12),
            ...[0.0, 3.0, 4.0, 4.5].map((r) => _RatingOption(
                  value: r,
                  selected: minRating == r,
                  onTap: () => onMinRatingChanged(r),
                )),

            const SizedBox(height: 24),
            _FilterDivider(label: 'Availability'),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14),
                ),
                const SizedBox(width: 10),
                Text('Available Now',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDivider extends StatelessWidget {
  final String label;
  const _FilterDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF94A3B8),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _CategoryOption extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryOption(
      {required this.label, required this.selected, required this.onTap});

  @override
  State<_CategoryOption> createState() => _CategoryOptionState();
}

class _CategoryOptionState extends State<_CategoryOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.accent.withValues(alpha: 0.1)
                : (_hovered ? const Color(0xFFF8FAFC) : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.selected
                  ? AppColors.accent.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: widget.selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: widget.selected
                      ? AppColors.accent
                      : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (widget.selected)
                const Icon(Icons.check_rounded,
                    size: 16, color: AppColors.accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingOption extends StatefulWidget {
  final double value;
  final bool selected;
  final VoidCallback onTap;
  const _RatingOption(
      {required this.value, required this.selected, required this.onTap});

  @override
  State<_RatingOption> createState() => _RatingOptionState();
}

class _RatingOptionState extends State<_RatingOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.value == 0
        ? 'Any Rating'
        : '${widget.value}+ Stars';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.accent.withValues(alpha: 0.1)
                : (_hovered ? const Color(0xFFF8FAFC) : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (widget.value > 0)
                Row(
                  children: List.generate(
                    widget.value.floor(),
                    (_) => const Icon(Icons.star_rounded,
                        color: Color(0xFFF59E0B), size: 14),
                  ),
                ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: widget.selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: widget.selected
                      ? AppColors.accent
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sort Chip ───────────────────────────────────────────────────────────────

class _SortChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SortChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  State<_SortChip> createState() => _SortChipState();
}

class _SortChipState extends State<_SortChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 8),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.accent
                : (_hovered
                    ? AppColors.accent.withValues(alpha: 0.08)
                    : AppColors.surface),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.selected
                  ? AppColors.accent
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.selected
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────

class _WebProductCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const _WebProductCard({required this.item});

  @override
  State<_WebProductCard> createState() => _WebProductCardState();
}

class _WebProductCardState extends State<_WebProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.item['name'] as String? ?? 'Equipment';
    final category = widget.item['category'] as String? ?? '';
    final price = widget.item['price'] as String? ?? '₹0/day';
    final rating = (widget.item['rating'] as num?)?.toDouble() ?? 0.0;
    final id = widget.item['id'] as String? ?? '1';
    final imageUrl = _itemImageUrl(name, category);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/equipment-detail/$id'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_hovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.25)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 6))
                  ]
                : AppColors.softShadow,
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.surfaceSubtle,
                              child: const Icon(Icons.image_outlined,
                                  color: Color(0xFFCBD5E1), size: 40)),
                      ),
                    ),
                    // Overlay on hover
                    if (_hovered)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18)),
                        child: Container(
                          color: AppColors.primary.withValues(alpha: 0.45),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 9),
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
                    // Category badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
                        name,
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
                      if (rating > 0)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFF59E0B), size: 13),
                            const SizedBox(width: 3),
                            Text(
                              '$rating',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accent,
                        ),
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

// ─── Mock fallback items ──────────────────────────────────────────────────────
final _mockItems = <Map<String, dynamic>>[
  {'id': '1', 'name': 'Professional PA System 5000W', 'price': '₹1,500/day', 'priceAmount': 1500.0, 'category': 'Sound', 'rating': 4.8},
  {'id': '2', 'name': 'LED Stage Lighting Kit', 'price': '₹2,000/day', 'priceAmount': 2000.0, 'category': 'Lighting', 'rating': 4.9},
  {'id': '3', 'name': 'Portable Stage Platform', 'price': '₹3,000/day', 'priceAmount': 3000.0, 'category': 'Staging', 'rating': 4.7},
  {'id': '4', 'name': 'Wireless Microphone Set', 'price': '₹800/day', 'priceAmount': 800.0, 'category': 'Sound', 'rating': 4.6},
  {'id': '5', 'name': 'Chiavari Chair Set (50)', 'price': '₹1,200/day', 'priceAmount': 1200.0, 'category': 'Furniture', 'rating': 4.5},
  {'id': '6', 'name': 'Large Shamiyana Tent', 'price': '₹5,000/day', 'priceAmount': 5000.0, 'category': 'Tent', 'rating': 4.8},
  {'id': '7', 'name': 'Floral Arch Decoration', 'price': '₹2,500/day', 'priceAmount': 2500.0, 'category': 'Decor', 'rating': 4.7},
  {'id': '8', 'name': 'DJ Controller Pro', 'price': '₹1,800/day', 'priceAmount': 1800.0, 'category': 'Sound', 'rating': 4.9},
  {'id': '9', 'name': '4K Laser Projector', 'price': '₹2,200/day', 'priceAmount': 2200.0, 'category': 'Lighting', 'rating': 4.6},
];
