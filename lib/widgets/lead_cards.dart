import 'package:flutter/material.dart';

import '../models/lead.dart';
import '../theme/leads_theme.dart';
import '../utils/lead_formatters.dart';

class LeadCard extends StatelessWidget {
  const LeadCard({
    super.key,
    required this.lead,
    required this.onTap,
    required this.onEmail,
    required this.onPhone,
  });

  final Lead lead;
  final VoidCallback onTap;
  final VoidCallback onEmail;
  final VoidCallback onPhone;

  Color get _avatarColor {
    switch (lead.status) {
      case LeadStatus.newLead:
        return const Color(0xFFE0F2FE);
      case LeadStatus.contacted:
        return const Color(0xFFFFECD9);
      case LeadStatus.qualified:
        return const Color(0xFFE0E7FF);
      case LeadStatus.failed:
        return const Color(0xFFFCE8E6);
    }
  }

  Color get _avatarInk {
    switch (lead.status) {
      case LeadStatus.newLead:
        return const Color(0xFF0284C7);
      case LeadStatus.contacted:
        return const Color(0xFF2563EB);
      case LeadStatus.qualified:
        return const Color(0xFF6366F1);
      case LeadStatus.failed:
        return const Color(0xFFB3261E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(21),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 112),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: cardDecoration(),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _avatarColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  lead.initials,
                  style: TextStyle(
                    color: _avatarInk,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lead.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead.company,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: LeadsColors.muted, fontSize: 11),
                    ),
                    const SizedBox(height: 9),
                    StatusPill(status: lead.status),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    lead.value > 0 ? formatCurrency(lead.value) : 'N/A',
                    style: const TextStyle(
                      color: Color(0xFF172B4D),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Est. value',
                    style: TextStyle(color: LeadsColors.muted, fontSize: 9),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              ContactButton(
                tooltip: 'Copy email',
                icon: Icons.mail_outline_rounded,
                onPressed: onEmail,
              ),
              const SizedBox(width: 5),
              ContactButton(
                tooltip: 'Copy phone',
                icon: Icons.call_outlined,
                onPressed: onPhone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  const ContactButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton.outlined(
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          foregroundColor: const Color(0xFF64748B),
          side: const BorderSide(color: LeadsColors.line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        ),
        icon: Icon(icon, size: 17),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});
  final LeadStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusLabel(status),
        style: TextStyle(
          color: statusInk(status),
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class LeadStatusFilterChip extends StatelessWidget {
  const LeadStatusFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          color: selected ? LeadsColors.forest : const Color(0xFF64748B),
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        backgroundColor: Colors.white,
        selectedColor: LeadsColors.mint,
        side: BorderSide(color: selected ? const Color(0xFFCFE3FA) : LeadsColors.line),
        showCheckmark: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      ),
    );
  }
}

class EmptyLeads extends StatelessWidget {
  const EmptyLeads({super.key, required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 26),
      decoration: cardDecoration(),
      child: Column(
        children: [
          const Icon(Icons.person_search_outlined, color: LeadsColors.forest, size: 34),
          const SizedBox(height: 10),
          const Text(
            'No matching leads',
            style: TextStyle(
              color: Color(0xFF172B4D),
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Try another filter or add companies to your pipeline.',
            textAlign: TextAlign.center,
            style: TextStyle(color: LeadsColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 13),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add companies'),
          ),
        ],
      ),
    );
  }
}

class DemoNote extends StatelessWidget {
  const DemoNote({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF7FF),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFDCEBFA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: LeadsColors.forest, size: 20),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Turn company names into leads',
                  style: TextStyle(
                    color: LeadsColors.deepForest,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Scrape, enrich with AI, and fill your lead sheet.',
                  style: TextStyle(color: LeadsColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Start enrichment',
            onPressed: onStart,
            style: IconButton.styleFrom(
              backgroundColor: LeadsColors.forest,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

