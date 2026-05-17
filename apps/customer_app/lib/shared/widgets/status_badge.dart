import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: _textColor),
      ),
    );
  }

  Color get _bgColor {
    switch (type) {
      case StatusType.success: return AppTheme.success.withOpacity(0.1);
      case StatusType.warning: return AppTheme.warning.withOpacity(0.1);
      case StatusType.error: return AppTheme.error.withOpacity(0.1);
      case StatusType.info: return AppTheme.primaryBlue.withOpacity(0.1);
      case StatusType.neutral: return AppTheme.border;
    }
  }

  Color get _textColor {
    switch (type) {
      case StatusType.success: return AppTheme.success;
      case StatusType.warning: return const Color(0xFFB45309);
      case StatusType.error: return AppTheme.error;
      case StatusType.info: return AppTheme.primaryBlue;
      case StatusType.neutral: return AppTheme.secondaryText;
    }
  }
}

enum StatusType { success, warning, error, info, neutral }
