part of '../lead_flow_home.dart';

extension _DashboardView on _LeadFlowHomeState {
  Widget _buildHomePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(25, 28, 25, 30),
      children: [
        _buildGreeting(),
        const SizedBox(height: 23),
        _buildPipelineCard(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.person_add_alt_1_rounded,
                title: 'New leads',
                value: '$_newLeads',
                caption: 'Ready for outreach',
                tint: const Color(0xFFE0F2FE),
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: MetricCard(
                icon: Icons.bar_chart_rounded,
                title: 'Conversion',
                value: '$_conversionRate%',
                caption: 'Qualified opportunities',
                tint: const Color(0xFFFFF0E0),
                iconColor: const Color(0xFFB66B23),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        SectionHeading(
          title: 'Priority leads',
          subtitle: 'Focus on your hottest opportunities',
          actionLabel: 'View all',
          onAction: () => _refresh(() => _selectedTab = 1),
        ),
        const SizedBox(height: 17),
        ..._leads
            .take(4)
            .map(
              (lead) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LeadCard(
                  lead: lead,
                  onTap: () => _showLeadDetails(lead),
                  onEmail: () => _copyContact(lead.email, 'Email'),
                  onPhone: () => _copyContact(lead.phone, 'Phone number'),
                ),
              ),
            ),
        if (_leads.length > 4) ...[
          const SizedBox(height: 3),
          Center(
            child: TextButton.icon(
              onPressed: () => _refresh(() => _selectedTab = 1),
              icon: const Icon(Icons.expand_more_rounded),
              label: Text('See all ${_leads.length} leads'),
            ),
          ),
        ],
        const SizedBox(height: 12),
        DemoNote(onStart: _openCampaignSheet),
      ],
    );
  }

  int get _conversionRate =>
      _leads.isEmpty ? 0 : (_qualifiedLeads * 100 / _leads.length).round();

  Widget _buildGreeting() {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    const weekdays = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                '$greeting, Alex',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(17),
              ),
              alignment: Alignment.center,
              child: const Text(
                'AK',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        const Text(
          "Here's what's happening with your leads.",
          style: TextStyle(color: AppColors.muted, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPipelineCard() {
    final value = _pipelineValue;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29469F), Color(0xFF2563EB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: -92,
            right: -58,
            child: Container(
              width: 176,
              height: 176,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 28,
                ),
              ),
            ),
          ),
          Positioned(
            top: -45,
            right: -18,
            child: Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 24, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pipeline value',
                            style: TextStyle(
                              color: Color(0xFFD5E7FF),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            formatCurrency(value),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 19),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.north_east_rounded,
                            color: Color(0xFFDCEBFF),
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_conversionRate%',
                            style: const TextStyle(
                              color: Color(0xFFE8F2FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      _progressSegment(_newLeads, const Color(0xFF7DD3FC)),
                      const SizedBox(width: 4),
                      _progressSegment(
                        _contactedLeads,
                        const Color(0xFFFFC06D),
                      ),
                      const SizedBox(width: 4),
                      _progressSegment(
                        _qualifiedLeads,
                        const Color(0xFFA797E6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 18,
                  runSpacing: 8,
                  children: [
                    LegendItem(
                      color: const Color(0xFF7DD3FC),
                      label: 'New',
                      count: _newLeads,
                    ),
                    LegendItem(
                      color: const Color(0xFFFFC06D),
                      label: 'Contacted',
                      count: _contactedLeads,
                    ),
                    LegendItem(
                      color: const Color(0xFFA797E6),
                      label: 'Qualified',
                      count: _qualifiedLeads,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressSegment(int count, Color color) {
    return Expanded(
      flex: count == 0 ? 1 : count,
      child: Container(
        height: 9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
