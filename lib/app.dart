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
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: LeadsColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: LeadsColors.forest,
          primary: LeadsColors.forest,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 27,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
          titleLarge: TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
          bodyMedium: TextStyle(color: Color(0xFF52657A), fontSize: 14),
        ),
      ),
      home: const LeadFlowHome(),
    );
  }
}
