part of '../lead_flow_home.dart';

extension _InsightsProfileView on _LeadFlowHomeState {
  Widget _buildInsightsPage() {
    final total = _leads.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(25, 28, 25, 30),
      children: [
        const SectionHeading(
          title: 'Insights',
          subtitle: 'A quick read on your lead pipeline',
        ),
        const SizedBox(height: 22),
        PipelineDetailCard(
          title: 'Lead status',
          subtitle: 'How your opportunities are moving',
          rows: [
            InsightRow(
              label: 'New',
              count: _newLeads,
              total: total,
              color: const Color(0xFF7DD3FC),
            ),
            InsightRow(
              label: 'Contacted',
              count: _contactedLeads,
              total: total,
              color: const Color(0xFFFFC06D),
            ),
            InsightRow(
              label: 'Qualified',
              count: _qualifiedLeads,
              total: total,
              color: const Color(0xFFA797E6),
            ),
          ],
        ),
        const SizedBox(height: 16),
        PipelineDetailCard(
          title: 'Pipeline snapshot',
          subtitle: 'Your current workspace at a glance',
          rows: [
            SnapshotRow(label: 'Total leads', value: '$total'),
            SnapshotRow(
              label: 'Estimated pipeline',
              value: formatCurrency(_pipelineValue),
            ),
            SnapshotRow(
              label: 'Qualified share',
              value: '$_conversionRate%',
            ),
          ],
        ),
        const SizedBox(height: 16),
        DemoNote(onStart: _openCampaignSheet),
      ],
    );
  }

  Widget _buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(25, 28, 25, 30),
      children: [
        const SectionHeading(
          title: 'Your profile',
          subtitle: 'Workspace preferences and connections',
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: cardDecoration(),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'AK',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alex Khan',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Lead researcher', style: TextStyle(color: AppColors.muted)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ProfileRow(
          icon: Icons.hub_outlined,
          title: 'Lead enrichment',
          subtitle: 'Scraper + AI pipeline',
          trailing: _isProcessing ? 'Running' : 'Ready',
          onTap: _openCampaignSheet,
        ),
        ProfileRow(
          icon: Icons.key_outlined,
          title: 'API connection',
          subtitle: 'FastAPI lead processing service',
          trailing: 'Configure',
          onTap: _showApiInfo,
        ),
        ProfileRow(
          icon: Icons.file_download_outlined,
          title: 'Export lead sheet',
          subtitle: 'Copy every lead as CSV',
          trailing: 'Export',
          onTap: _exportLeads,
        ),
        const SizedBox(height: 18),
        DemoNote(onStart: _openCampaignSheet),
      ],
    );
  }


}
