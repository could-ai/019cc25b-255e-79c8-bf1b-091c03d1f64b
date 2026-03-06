import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AIAnalyticsWidget extends StatelessWidget {
  const AIAnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    
    // Mock AI predictions and alerts
    final predictions = _generatePredictions(appState);
    final alerts = _generateAlerts(appState);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Analytics Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Budget Alerts
          if (alerts.isNotEmpty) ...[
            Text(
              'Budget Alerts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...alerts.map((alert) => Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text(alert),
              ),
            )),
            const SizedBox(height: 32),
          ],
          
          // Budget Predictions
          Text(
            'Budget Predictions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...predictions.map((prediction) => Card(
            child: ListTile(
              leading: const Icon(Icons.trending_up),
              title: Text(prediction['project']!),
              subtitle: Text(prediction['prediction']!),
            ),
          )),
          
          const SizedBox(height: 32),
          
          // Spending Trend Chart
          Text(
            'Spending Trends',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 10000),
                      const FlSpot(1, 15000),
                      const FlSpot(2, 12000),
                      const FlSpot(3, 18000),
                      const FlSpot(4, 22000),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List&lt;String&gt; _generateAlerts(AppState appState) {
    final alerts = &lt;String&gt;[];
    for (var project in appState.projects) {
      final totalUsed = appState.getTotalBudgetUsed(project.id);
      final usagePercentage = project.totalBudget > 0 ? (totalUsed / project.totalBudget) * 100 : 0;
      if (usagePercentage >= 80) {
        alerts.add('${project.name} has used ${usagePercentage.toStringAsFixed(1)}% of its allocated budget.');
      }
    }
    return alerts;
  }

  List&lt;Map&lt;String, String&gt;&gt; _generatePredictions(AppState appState) {
    final predictions = &lt;Map&lt;String, String&gt;&gt;[];
    for (var project in appState.projects) {
      final totalUsed = appState.getTotalBudgetUsed(project.id);
      final remaining = project.totalBudget - totalUsed;
      
      // Mock prediction logic
      final daysToExhaustion = remaining > 0 ? (remaining / 5000).round() : 0; // Mock daily spend
      
      predictions.add({
        'project': project.name,
        'prediction': 'Budget expected to be exhausted in approximately $daysToExhaustion days based on current spending patterns.',
      });
    }
    return predictions;
  }
}