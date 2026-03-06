import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class BudgetHeadsTable extends StatefulWidget {
  final Project project;

  const BudgetHeadsTable({super.key, required this.project});

  @override
  State&lt;BudgetHeadsTable&gt; createState() => _BudgetHeadsTableState();
}

class _BudgetHeadsTableState extends State&lt;BudgetHeadsTable&gt; {
  Future&lt;void&gt; _uploadExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      // TODO: Parse Excel file and extract budget heads
      // For now, add mock budget heads
      final appState = Provider.of&lt;AppState&gt;(context, listen: false);
      
      // Mock data - in real implementation, parse Excel
      final mockBudgetHeads = {
        'Subcontractor': BudgetHead(name: 'Subcontractor', allocatedCost: 50000.0),
        'Materials': BudgetHead(name: 'Materials', allocatedCost: 30000.0),
        'Labor': BudgetHead(name: 'Labor', allocatedCost: 20000.0),
      };
      
      // Update project with budget heads
      final updatedProject = Project(
        id: widget.project.id,
        name: widget.project.name,
        region: widget.project.region,
        totalBudget: mockBudgetHeads.values.fold(0.0, (sum, head) => sum + head.allocatedCost),
        budgetHeads: mockBudgetHeads,
      );
      
      // Replace in projects list
      final projects = appState.projects;
      final index = projects.indexWhere((p) => p.id == widget.project.id);
      if (index != -1) {
        projects[index] = updatedProject;
        appState.notifyListeners();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget heads uploaded successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetHeads = widget.project.budgetHeads;
    final appState = Provider.of&lt;AppState&gt;(context);
    final budgetHeadUsage = appState.getBudgetHeadUsage(widget.project.id);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Heads',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton.icon(
                onPressed: _uploadExcel,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Excel'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (budgetHeads.isEmpty)
            const Center(
              child: Text('No budget heads uploaded yet. Upload an Excel file to get started.'),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Estimation Head')),
                  DataColumn(label: Text('Allocated Cost')),
                  DataColumn(label: Text('Used Cost')),
                  DataColumn(label: Text('Remaining Cost')),
                ],
                rows: budgetHeads.values.map((head) {
                  final used = budgetHeadUsage[head.name] ?? 0.0;
                  final remaining = head.allocatedCost - used;
                  return DataRow(cells: [
                    DataCell(Text(head.name)),
                    DataCell(Text('₹${head.allocatedCost.toStringAsFixed(2)}')),
                    DataCell(Text('₹${used.toStringAsFixed(2)}')),
                    DataCell(Text('₹${remaining.toStringAsFixed(2)}')),
                  ]);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}