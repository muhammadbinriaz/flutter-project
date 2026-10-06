import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leads_generation_mvp/models/lead.dart';
import 'package:leads_generation_mvp/main.dart';

void main() {
  test('missing lead fields stay null instead of becoming fake values', () {
    final lead = Lead.fromJson({'company': 'Acme', 'status': 'completed'});

    expect(lead.email, isNull);
    expect(lead.error, isNull);
    expect(lead.company, 'Acme');
    expect(lead.name, 'Acme');
  });

  testWidgets('dashboard shows leads pipeline and priority leads', (
    tester,
  ) async {
    await tester.pumpWidget(const LeadsMvpApp());

    expect(find.text('Leads MVP'), findsOneWidget);
    expect(find.text('Pipeline value'), findsOneWidget);
    expect(find.text('\$48,250'), findsOneWidget);
    expect(find.byTooltip('Notifications'), findsOneWidget);
  });

  testWidgets('leads tab filters to qualified leads', (tester) async {
    await tester.pumpWidget(const LeadsMvpApp());

    await tester.tap(find.text('Leads').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Qualified'));
    await tester.pumpAndSettle();

    expect(find.text('Olivia Rodriguez'), findsOneWidget);
    expect(find.text('Daniel Brooks'), findsOneWidget);
    expect(find.text('James Mitchell'), findsNothing);
  });

  testWidgets('add button opens a company enrichment form', (tester) async {
    await tester.pumpWidget(const LeadsMvpApp());

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Find your next leads'), findsOneWidget);
    expect(find.text('COMPANIES OR WEBSITES'), findsOneWidget);
    expect(find.text('Run lead enrichment'), findsOneWidget);
  });
}
