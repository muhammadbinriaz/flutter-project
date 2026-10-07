import 'package:flutter/material.dart';

import 'screens/lead_flow_home.dart';
import 'theme/leads_theme.dart';

class LeadsMvpApp extends StatelessWidget {
  const LeadsMvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leads MVP',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LeadFlowHome(),
    );
  }
}
