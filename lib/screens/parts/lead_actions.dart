part of '../lead_flow_home.dart';

extension _LeadActions on _LeadFlowHomeState {
  Future<void> _openCampaignSheet() async {
    final companies = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CampaignSheet(),
    );
    if (companies == null || !mounted) return;
    final inputs = companies
        .split(RegExp(r'[\r\n,]+'))
        .map((company) => company.trim())
        .where((company) => company.isNotEmpty)
        .toSet()
        .toList();
    if (inputs.isEmpty) return;

    _refresh(() {
      _isProcessing = true;
      _processed = 0;
      _total = inputs.length;
      _currentCompany = null;
    });

    try {
      final job = await LeadApi.startProcess(inputs);
      if (!mounted) return;
      if (job.results.isNotEmpty) _mergeResults(job.results);

      while (mounted) {
        final status = await LeadApi.getJobStatus(job.jobId);
        if (!mounted) return;
        _refresh(() {
          _processed = status.completed;
          _total = status.total;
          _currentCompany = status.current;
        });
        _mergeResults(status.results);
        if (status.completed >= status.total) break;
        await Future<void>.delayed(const Duration(seconds: 2));
      }
      if (!mounted) return;
      _refresh(() {
        _isProcessing = false;
        _currentCompany = null;
      });
      _showMessage(
        'Enrichment complete · ${inputs.length} companies processed',
      );
    } catch (error) {
      if (!mounted) return;
      _refresh(() {
        _isProcessing = false;
        _currentCompany = null;
      });
      _showMessage('Could not process leads: $error');
    }
  }

  void _mergeResults(List<Lead> results) {
    if (!mounted || results.isEmpty) return;
    _refresh(() {
      for (final lead in results) {
        final index = _leads.indexWhere(
          (existing) =>
              existing.company.toLowerCase() == lead.company.toLowerCase(),
        );
        if (index == -1) {
          _leads.insert(0, lead);
        } else {
          _leads[index] = lead;
        }
      }
    });
  }

  void _showLeadDetails(Lead lead) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LeadDetailsSheet(lead: lead),
    );
  }

  Future<void> _copyContact(String? value, String label) async {
    if (value == null || value.trim().isEmpty) {
      _showMessage('$label not available for this lead yet.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: value));
    if (mounted) _showMessage('$label copied to clipboard');
  }

  Future<void> _exportLeads() async {
    if (_leads.isEmpty) {
      _showMessage('There are no leads to export yet.');
      return;
    }
    final rows = <List<String>>[
      [
        'Name',
        'Company',
        'Title',
        'Email',
        'Email source',
        'Phone',
        'Industry',
        'Company size',
        'Website',
        'LinkedIn',
        'ICP tags',
        'Cold email draft',
        'Estimated value',
        'Status',
        'Error',
      ],
      ..._leads.map(
        (lead) => [
          lead.name,
          lead.company,
          lead.title ?? 'Title not found',
          lead.email ?? 'Email not found',
          lead.emailSource ?? 'Source not provided',
          lead.phone ?? 'Phone not found',
          lead.industry ?? 'Industry not found',
          lead.size ?? 'Company size not found',
          lead.website ?? 'Website not found',
          lead.linkedin ?? 'LinkedIn not found',
          lead.icpTags.isEmpty ? 'Tags not found' : lead.icpTags.join('; '),
          lead.coldEmail ?? 'Draft not available',
          lead.value > 0 ? formatCurrency(lead.value) : 'Not estimated',
          statusLabel(lead.status),
          lead.error ?? 'No error',
        ],
      ),
    ];
    final csv = rows.map((row) => row.map(_escapeCsv).join(',')).join('\r\n');
    try {
      final path = await FileSaver.instance.saveAs(
        name: 'leads_mvp',
        bytes: Uint8List.fromList(utf8.encode(csv)),
        fileExtension: 'csv',
        mimeType: MimeType.csv,
      );
      if (!mounted) return;
      _showMessage(
        path == null ? 'CSV export cancelled.' : 'Lead sheet exported as CSV.',
      );
    } catch (error) {
      if (mounted) _showMessage('Could not export lead sheet: $error');
    }
  }

  String _escapeCsv(String value) => '"${value.replaceAll('"', '""')}"';

  void _showNotifications() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 18),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: LeadsColors.mint,
                  child: Icon(Icons.bolt_rounded, color: LeadsColors.forest),
                ),
                title: Text('Your lead workspace is ready'),
                subtitle: Text('Add company names to start an enrichment run.'),
              ),
              if (_isProcessing)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFF0E0),
                    child: Icon(Icons.sync_rounded, color: Color(0xFFB66B23)),
                  ),
                  title: const Text('Lead enrichment in progress'),
                  subtitle: Text('$_processed of $_total companies processed'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApiInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect your lead engine'),
        content: const Text(
          'The app sends company names to the existing FastAPI /process '
          'endpoint, then checks /process/{job_id}/status for scraped and '
          'AI-enriched results. Start your backend first. For an Android '
          'emulator the default API address is 10.0.2.2:8000.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}
