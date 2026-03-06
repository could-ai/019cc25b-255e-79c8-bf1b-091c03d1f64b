import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetSummary extends StatelessWidget {
  final double totalBudget;
  final double totalUsed;
  final double remaining;

  const BudgetSummary({
    super.key,
    required this.totalBudget,
    required this.totalUsed,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final usedPercentage = totalBudget > 0 ? (totalUsed / totalBudget) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Summary',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Budget Allocated',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '₹${totalBudget.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Budget Used',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '₹${totalUsed.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Budget Remaining',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '₹${remaining.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: remaining >= 0 ? Colors.blue : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Budget Usage Chart',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: totalUsed,
                    title: '${usedPercentage.toStringAsFixed(1)}%',
                    color: Colors.orange,
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: remaining,
                    title: '${(100 - usedPercentage).toStringAsFixed(1)}%',
                    color: Colors.green,
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}