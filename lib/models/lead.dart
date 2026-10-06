enum LeadStatus { newLead, contacted, qualified, failed }

class Lead {
  const Lead({
    required this.name,
    required this.company,
    required this.status,
    required this.value,
    this.email,
    this.emailSource,
    this.phone,
    this.title,
    this.industry,
    this.size,
    this.website,
    this.linkedin,
    this.icpTags = const [],
    this.coldEmail,
    this.error,
  });

  final String name;
  final String company;
  final LeadStatus status;
  final int value;
  final String? email;
  final String? emailSource;
  final String? phone;
  final String? title;
  final String? industry;
  final String? size;
  final String? website;
  final String? linkedin;
  final List<String> icpTags;
  final String? coldEmail;
  final String? error;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.length == 1
        ? parts.first.substring(0, 1).toUpperCase()
        : '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
            .toUpperCase();
  }

  factory Lead.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'] as String? ?? 'new';
    final status = switch (rawStatus) {
      'completed' || 'qualified' => LeadStatus.qualified,
      'contacted' => LeadStatus.contacted,
      'failed' => LeadStatus.failed,
      _ => LeadStatus.newLead,
    };
    final rawTags = json['icp_tags'];
    final company = _display(json['company'], 'Company not found');
    return Lead(
      name: _display(json['contact_name'], company),
      company: company,
      status: status,
      value: 0,
      email: _optionalText(json['email']),
      emailSource: _optionalText(json['email_source']),
      title: _optionalText(json['contact_title']),
      industry: _optionalText(json['industry']),
      size: _optionalText(json['size']),
      website: _optionalText(json['website']),
      linkedin: _optionalText(json['linkedin']),
      icpTags: rawTags is List
          ? rawTags.whereType<String>().where((tag) => tag.isNotEmpty).toList()
          : const [],
      coldEmail: _optionalText(json['cold_email']),
      error: _optionalText(json['error']),
    );
  }
}

String _display(Object? value, String fallback) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  return fallback;
}

String? _optionalText(Object? value) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  return null;
}
