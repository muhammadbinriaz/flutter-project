import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/lead.dart';

class LeadApi {
  static const _configuredUrl = String.fromEnvironment('API_BASE_URL');

  static String get _baseUrl {
    if (_configuredUrl.isNotEmpty) {
      return _configuredUrl.replaceAll(RegExp(r'/$'), '');
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  static Future<({String jobId, List<Lead> results})> startProcess(
    List<String> companies,
  ) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/process'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'companies': companies}),
        )
        .timeout(const Duration(seconds: 25));
    final body = _decodeResponse(response);
    final jobId = body['job_id'];
    if (jobId is! String || jobId.isEmpty) {
      throw const FormatException('The API did not return a job ID.');
    }
    return (
      jobId: jobId,
      results: _readLeads(body['results']),
    );
  }

  static Future<({int completed, String? current, List<Lead> results, int total})>
      getJobStatus(String jobId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/process/$jobId/status'))
        .timeout(const Duration(seconds: 25));
    final body = _decodeResponse(response);
    final completed = body['completed'];
    final total = body['total'];
    if (completed is! int || total is! int) {
      throw const FormatException('The API returned invalid job progress.');
    }
    return (
      completed: completed,
      total: total,
      current: body['current'] as String?,
      results: _readLeads(body['results']),
    );
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw FormatException(
        'Lead API returned an unreadable response (${response.statusCode}).',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Lead API returned an unexpected response.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final detail = decoded['detail'];
      throw Exception(
        detail is String ? detail : 'Request failed (${response.statusCode}).',
      );
    }
    return decoded;
  }

  static List<Lead> _readLeads(Object? value) {
    if (value is! List) {
      throw const FormatException('Lead API response is missing its results.');
    }
    return value.map((row) {
      if (row is! Map<String, dynamic>) {
        throw const FormatException('Lead API returned an invalid lead row.');
      }
      return Lead.fromJson(row);
    }).toList();
  }
}
