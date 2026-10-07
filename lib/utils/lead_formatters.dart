import 'package:flutter/material.dart';

import '../models/lead.dart';
import '../theme/leads_theme.dart';

String formatCurrency(int value) {
  final digits = value.toString();
  final result = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) result.write(',');
    result.write(digits[i]);
  }
  return '\$$result';
}

String statusLabel(LeadStatus status) => switch (status) {
      LeadStatus.newLead => 'New',
      LeadStatus.contacted => 'Contacted',
      LeadStatus.qualified => 'Qualified',
      LeadStatus.failed => 'Failed',
    };

Color statusColor(LeadStatus status) => switch (status) {
      LeadStatus.newLead => const Color(0xFFE5F3FB),
      LeadStatus.contacted => const Color(0xFFFFF0E0),
      LeadStatus.qualified => const Color(0xFFE0F2FE),
      LeadStatus.failed => const Color(0xFFFCE8E6),
    };

Color statusInk(LeadStatus status) => switch (status) {
      LeadStatus.newLead => const Color(0xFF2777A4),
      LeadStatus.contacted => const Color(0xFFB66B23),
      LeadStatus.qualified => const Color(0xFF2563EB),
      LeadStatus.failed => const Color(0xFFB3261E),
    };

BoxDecoration cardDecoration() => BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(21),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080D2B1F),
          blurRadius: 15,
          offset: Offset(0, 5),
        ),
      ],
    );

