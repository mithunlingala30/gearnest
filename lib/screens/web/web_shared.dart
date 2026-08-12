import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

/// Shared form field used by [WebLoginScreen] and [WebSignupScreen].
class WebFormField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const WebFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  @override
  State<WebFormField> createState() => _WebFormFieldState();
}

class _WebFormFieldState extends State<WebFormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscure,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 15, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFCBD5E1), fontSize: 14),
              prefixIcon: Icon(widget.icon,
                  color: _focused
                      ? AppColors.accent
                      : const Color(0xFF94A3B8),
                  size: 20),
              suffixIcon: widget.suffix,
              filled: true,
              fillColor: _focused
                  ? const Color(0xFFF0FDFF)
                  : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.accent, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColors.danger, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

/// Grid mesh background painter used on dark brand panels.
class WebMeshPainter extends CustomPainter {
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
