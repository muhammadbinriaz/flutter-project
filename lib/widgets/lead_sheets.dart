import 'package:flutter/material.dart';

import '../models/lead.dart';
import '../theme/leads_theme.dart';
import 'lead_cards.dart';

class CampaignSheet extends StatefulWidget {
  const CampaignSheet({super.key});

  @override
  State<CampaignSheet> createState() => _CampaignSheetState();
}

class _CampaignSheetState extends State<CampaignSheet> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(23, 12, 23, bottomInset + 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEAF5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 21),
            const Text(
              'Find your next leads',
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Add companies or websites. We’ll scrape and enrich each one.',
              style: TextStyle(color: LeadsColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 20),
            const Text(
              'COMPANIES OR WEBSITES',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              minLines: 4,
              maxLines: 7,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Acme Corp\nGlobex\nhttps://initech.io',
                alignLabelWithHint: true,
                filled: true,
                fillColor: LeadsColors.canvas,
                errorText: _error,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: LeadsColors.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: LeadsColors.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: LeadsColors.forest,
                    width: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: LeadsColors.forest,
                  size: 15,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Scraper + Groq AI · results fill your lead sheet',
                    style: TextStyle(color: LeadsColors.muted, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 19),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  final companies = _controller.text
                      .split(RegExp(r'[\r\n,]+'))
                      .map((company) => company.trim())
                      .where((company) => company.isNotEmpty)
                      .toSet();
                  if (companies.isEmpty) {
                    setState(() => _error = 'Enter at least one company.');
                    return;
                  }
                  Navigator.pop(context, _controller.text);
                },
                icon: const Icon(Icons.bolt_rounded, size: 19),
                label: const Text(
                  'Run lead enrichment',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: LeadsColors.forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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

class LeadDetailsSheet extends StatelessWidget {
  const LeadDetailsSheet({super.key, required this.lead});
  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        23,
        12,
        23,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDCEAF5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: LeadsColors.mint,
                child: Text(
                  lead.initials,
                  style: const TextStyle(
                    color: LeadsColors.forest,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name,
                      style: const TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      lead.company,
                      style: const TextStyle(color: LeadsColors.muted),
                    ),
                  ],
                ),
              ),
              StatusPill(status: lead.status),
            ],
          ),
          const SizedBox(height: 18),
          DetailRow(label: 'Title', value: lead.title ?? 'Title not found'),
          DetailRow(label: 'Email', value: lead.email ?? 'Email not found'),
          DetailRow(
            label: 'Industry',
            value: lead.industry ?? 'Industry not found',
          ),
          DetailRow(
            label: 'Company size',
            value: lead.size ?? 'Company size not found',
          ),
          DetailRow(
            label: 'Website',
            value: lead.website ?? 'Website not found',
          ),
          DetailRow(
            label: 'LinkedIn',
            value: lead.linkedin ?? 'LinkedIn not found',
          ),
          DetailRow(
            label: 'Email source',
            value: lead.emailSource ?? 'Source not provided',
          ),
          DetailRow(
            label: 'ICP tags',
            value: lead.icpTags.isEmpty
                ? 'Tags not found'
                : lead.icpTags.join(', '),
          ),
          DetailRow(
            label: 'Cold email',
            value: lead.coldEmail ?? 'Draft not available',
          ),
          if (lead.error != null && lead.error!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 11),
              child: Text(
                'Pipeline note: ${lead.error}',
                style: const TextStyle(color: Color(0xFFB66B23), fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: const TextStyle(
                color: LeadsColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF29415F),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
