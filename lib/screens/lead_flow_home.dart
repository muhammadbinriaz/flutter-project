import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_saver/file_saver.dart';

import '../models/lead.dart';
import '../services/lead_api.dart';
import '../theme/leads_theme.dart';
import '../utils/lead_formatters.dart';
import '../widgets/lead_sheets.dart';
import '../widgets/lead_cards.dart';
import '../widgets/dashboard_widgets.dart';

part 'parts/app_chrome_top.dart';
part 'parts/dashboard_view.dart';
part 'parts/leads_view.dart';
part 'parts/insights_profile_view.dart';
part 'parts/app_chrome_bottom.dart';
part 'parts/lead_actions.dart';

class LeadFlowHome extends StatefulWidget {
  const LeadFlowHome({super.key});

  @override
  State<LeadFlowHome> createState() => _LeadFlowHomeState();
}

class _LeadFlowHomeState extends State<LeadFlowHome> {
  final List<Lead> _leads = [
    const Lead(
      name: 'Olivia Rodriguez',
      company: 'Northstar Labs',
      status: LeadStatus.qualified,
      value: 12500,
      email: 'olivia@northstarlabs.example',
      title: 'VP of Operations',
      industry: 'Technology',
    ),
    const Lead(
      name: 'James Mitchell',
      company: 'Aperture Group',
      status: LeadStatus.newLead,
      value: 8200,
      email: 'james@aperture.example',
      title: 'Managing Director',
      industry: 'Professional services',
    ),
    const Lead(
      name: 'Sarah Kim',
      company: 'Vercelion Studio',
      status: LeadStatus.contacted,
      value: 6400,
      email: 'sarah@vercelion.example',
      title: 'Founder',
      industry: 'Design',
    ),
    const Lead(
      name: 'Daniel Brooks',
      company: 'Evergreen Systems',
      status: LeadStatus.qualified,
      value: 5800,
      email: 'daniel@evergreen.example',
      title: 'Head of Growth',
      industry: 'Software',
    ),
    const Lead(
      name: 'Priya Shah',
      company: 'Brightpath Health',
      status: LeadStatus.newLead,
      value: 5350,
      email: 'priya@brightpath.example',
      title: 'Director of Partnerships',
      industry: 'Healthcare',
    ),
    const Lead(
      name: 'Marcus Lee',
      company: 'Fieldstone Works',
      status: LeadStatus.contacted,
      value: 10000,
      email: 'marcus@fieldstone.example',
      title: 'Chief Executive Officer',
      industry: 'Business services',
    ),
  ];

  int _selectedTab = 0;
  LeadStatus? _statusFilter;
  String _searchQuery = '';
  bool _searchVisible = false;
  bool _isProcessing = false;
  int _processed = 0;
  int _total = 0;
  String? _currentCompany;

  List<Lead> get _filteredLeads => _leads.where((lead) {
    final matchesStatus = _statusFilter == null || lead.status == _statusFilter;
    final query = _searchQuery.trim().toLowerCase();
    final matchesSearch =
        query.isEmpty ||
        lead.name.toLowerCase().contains(query) ||
        lead.company.toLowerCase().contains(query) ||
        (lead.email ?? '').toLowerCase().contains(query);
    return matchesStatus && matchesSearch;
  }).toList();

  int get _pipelineValue => _leads.fold(0, (total, lead) => total + lead.value);
  int get _newLeads =>
      _leads.where((lead) => lead.status == LeadStatus.newLead).length;
  int get _contactedLeads =>
      _leads.where((lead) => lead.status == LeadStatus.contacted).length;
  int get _qualifiedLeads =>
      _leads.where((lead) => lead.status == LeadStatus.qualified).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                _buildTopBar(),
                if (_isProcessing) _buildProcessingBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTab,
                    children: [
                      _buildHomePage(),
                      _buildLeadsPage(),
                      _buildInsightsPage(),
                      _buildProfilePage(),
                    ],
                  ),
                ),
                _buildBottomNavigation(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _refresh(VoidCallback update) => setState(update);
}
