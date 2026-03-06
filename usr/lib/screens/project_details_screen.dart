import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/budget_summary.dart';
import '../widgets/budget_heads_table.dart';
import '../widgets/spo_list.dart';
import '../widgets/cop_list.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final totalUsed = appState.getTotalBudgetUsed(project.id);
    final remaining = project.totalBudget - totalUsed;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Budget Summary'),
              Tab(text: 'Budget Heads'),
              Tab(text: 'SPOs'),
              Tab(text: 'COPs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BudgetSummary(
              totalBudget: project.totalBudget,
              totalUsed: totalUsed,
              remaining: remaining,
            ),
            BudgetHeadsTable(project: project),
            SPOList(projectId: project.id),
            COPList(projectId: project.id),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Add new item based on current tab
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}