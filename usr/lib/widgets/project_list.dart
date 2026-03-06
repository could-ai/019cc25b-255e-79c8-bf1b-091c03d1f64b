import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../screens/project_details_screen.dart';

class ProjectList extends StatelessWidget {
  final String region;

  const ProjectList({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final projects = appState.getProjectsByRegion(region);

    if (projects.isEmpty) {
      return const Center(
        child: Text('No projects found in this region'),
      );
    }

    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        final totalUsed = appState.getTotalBudgetUsed(project.id);
        final remaining = project.totalBudget - totalUsed;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(project.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Region: ${project.region}'),
                Text('Total Budget: ₹${project.totalBudget.toStringAsFixed(2)}'),
                Text('Used: ₹${totalUsed.toStringAsFixed(2)}'),
                Text('Remaining: ₹${remaining.toStringAsFixed(2)}'),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(project: project),
                ),
              );
            },
          ),
        );
      },
    );
  }
}