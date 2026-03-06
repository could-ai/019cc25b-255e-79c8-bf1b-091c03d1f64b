import 'package:flutter/material.dart';
import '../widgets/ai_analytics_widget.dart';

class AIAnalyticsScreen extends StatelessWidget {
  const AIAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analytics'),
      ),
      body: const SingleChildScrollView(
        child: AIAnalyticsWidget(),
      ),
    );
  }
}