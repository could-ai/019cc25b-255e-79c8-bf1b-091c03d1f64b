import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class VendorSummaryTable extends StatelessWidget {
  final String projectId;
  final String type; // 'SPO' or 'COP'

  const VendorSummaryTable({super.key, required this.projectId, required this.type});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final vendors = appState.vendors;
    
    // Calculate summary data based on type
    final summaryData = type == 'SPO' 
        ? _calculateSPOSummary(appState, projectId)
        : _calculateCOPSummary(appState, projectId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vendor Summary - $type',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Vendor')),
                    const DataColumn(label: Text('PO Amount')),
                    DataColumn(label: Text('Total ${type} Raised')),
                  ],
                  rows: vendors.map((vendor) {
                    final raised = summaryData[vendor.name] ?? 0.0;
                    return DataRow(cells: [
                      DataCell(Text(vendor.name)),
                      DataCell(Text('₹${vendor.poAmount.toStringAsFixed(2)}')),
                      DataCell(Text('₹${raised.toStringAsFixed(2)}')),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map&lt;String, double&gt; _calculateSPOSummary(AppState appState, String projectId) {
    final spos = appState.getSPObyProject(projectId);
    final summary = &lt;String, double&gt;{};
    for (var spo in spos) {
      summary[spo.vendorName] = (summary[spo.vendorName] ?? 0) + spo.amount;
    }
    return summary;
  }

  Map&lt;String, double&gt; _calculateCOPSummary(AppState appState, String projectId) {
    final cops = appState.getCOPbyProject(projectId).where((cop) => cop.status == 'Approved');
    final summary = &lt;String, double&gt;{};
    for (var cop in cops) {
      summary[cop.vendorName] = (summary[cop.vendorName] ?? 0) + cop.amount;
    }
    return summary;
  }
}