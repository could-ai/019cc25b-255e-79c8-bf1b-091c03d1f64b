import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/region_card.dart';
import '../widgets/project_list.dart';
import '../widgets/navigation_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State&lt;DashboardScreen&gt; createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State&lt;DashboardScreen&gt; {
  String? _selectedRegion;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Regional Budget Management System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              appState.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      drawer: const NavigationDrawer(),
      body: Row(
        children: [
          // Regions panel
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Regions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: appState.regions.length,
                      itemBuilder: (context, index) {
                        final region = appState.regions[index];
                        return RegionCard(
                          region: region,
                          isSelected: _selectedRegion == region,
                          onTap: () {
                            setState(() {
                              _selectedRegion = region;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Projects panel
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedRegion != null
                        ? 'Projects in $_selectedRegion'
                        : 'Select a region to view projects',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _selectedRegion != null
                        ? ProjectList(region: _selectedRegion!)
                        : const Center(
                            child: Text('Please select a region'),
                          ),
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