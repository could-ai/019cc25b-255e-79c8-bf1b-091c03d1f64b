import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/cop_list.dart';

class COPModuleScreen extends StatelessWidget {
  const COPModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final projects = appState.projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('COP Module'),
      ),
      body: projects.isEmpty
          ? const Center(child: Text('No projects available'))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ExpansionTile(
                  title: Text(project.name),
                  subtitle: Text('Region: ${project.region}'),
                  children: [
                    COPList(projectId: project.id),
                  ],
                );
              },
            ),
    );
  }
}