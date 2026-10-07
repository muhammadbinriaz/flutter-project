part of '../lead_flow_home.dart';

extension _LeadsView on _LeadFlowHomeState {
  Widget _buildLeadsPage() {
    final leads = _filteredLeads;
    return ListView(
      padding: const EdgeInsets.fromLTRB(25, 27, 25, 30),
      children: [
        SectionHeading(
          title: 'Priority leads',
          subtitle: '${_leads.length} opportunities in your pipeline',
          actionLabel: 'Export',
          onAction: _exportLeads,
        ),
        if (_searchVisible) ...[
          const SizedBox(height: 16),
          TextField(
            autofocus: true,
            onChanged: (value) => _refresh(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search leads or companies',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _refresh(() {
                    _searchQuery = '';
                    _searchVisible = false;
                  });
                },
                icon: const Icon(Icons.close_rounded),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              LeadStatusFilterChip(
                label: 'All',
                selected: _statusFilter == null,
                onTap: () => _refresh(() => _statusFilter = null),
              ),
              LeadStatusFilterChip(
                label: 'New',
                selected: _statusFilter == LeadStatus.newLead,
                onTap: () =>
                    _refresh(() => _statusFilter = LeadStatus.newLead),
              ),
              LeadStatusFilterChip(
                label: 'Contacted',
                selected: _statusFilter == LeadStatus.contacted,
                onTap: () =>
                    _refresh(() => _statusFilter = LeadStatus.contacted),
              ),
              LeadStatusFilterChip(
                label: 'Qualified',
                selected: _statusFilter == LeadStatus.qualified,
                onTap: () =>
                    _refresh(() => _statusFilter = LeadStatus.qualified),
              ),
              const SizedBox(width: 3),
              IconButton.outlined(
                tooltip: 'Search leads',
                onPressed: () => _refresh(() => _searchVisible = true),
                style: IconButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        if (leads.isEmpty)
          EmptyLeads(onAdd: _openCampaignSheet)
        else
          ...leads.map(
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
        const SizedBox(height: 12),
        DemoNote(onStart: _openCampaignSheet),
      ],
    );
  }


}
