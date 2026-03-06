import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/cop_form.dart';

class COPList extends StatefulWidget {
  final String projectId;

  const COPList({super.key, required this.projectId});

  @override
  State&lt;COPList&gt; createState() => _COPListState();
}

class _COPListState extends State&lt;COPList&gt; {
  String _statusFilter = 'All';
  String _vendorFilter = 'All';
  String _budgetHeadFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final project = appState.projects.firstWhere((p) => p.id == widget.projectId);
    var cops = appState.getCOPbyProject(widget.projectId);

    // Apply filters
    if (_statusFilter != 'All') {
      cops = cops.where((cop) => cop.status == _statusFilter).toList();
    }
    if (_vendorFilter != 'All') {
      cops = cops.where((cop) => cop.vendorName == _vendorFilter).toList();
    }
    if (_budgetHeadFilter != 'All') {
      cops = cops.where((cop) => cop.budgetHead == _budgetHeadFilter).toList();
    }

    final budgetHeads = project.budgetHeads.keys.toList();

    return Column(
      children: [
        // Filters and Actions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 150,
                child: DropdownButtonFormField&lt;String&gt;(
                  value: _statusFilter,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['All', 'Pending', 'Approved', 'Rejected']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) => setState(() => _statusFilter = value!),
                ),
              ),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField&lt;String&gt;(
                  value: _vendorFilter,
                  decoration: const InputDecoration(labelText: 'Vendor'),
                  items: ['All', ...appState.vendors.map((v) => v.name)]
                      .map((vendor) => DropdownMenuItem(value: vendor, child: Text(vendor)))
                      .toList(),
                  onChanged: (value) => setState(() => _vendorFilter = value!),
                ),
              ),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField&lt;String&gt;(
                  value: _budgetHeadFilter,
                  decoration: const InputDecoration(labelText: 'Budget Head'),
                  items: ['All', ...budgetHeads]
                      .map((head) => DropdownMenuItem(value: head, child: Text(head)))
                      .toList(),
                  onChanged: (value) => setState(() => _budgetHeadFilter = value!),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddCOPDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add COP'),
              ),
            ],
          ),
        ),
        // Vendor Summary
        VendorSummaryTable(projectId: widget.projectId, type: 'COP'),
        // COP List
        Expanded(
          child: ListView.builder(
            itemCount: cops.length,
            itemBuilder: (context, index) {
              final cop = cops[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text('COP ${cop.copNumber}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vendor: ${cop.vendorName}'),
                      Text('Budget Head: ${cop.budgetHead}'),
                      Text('Amount: ₹${cop.amount.toStringAsFixed(2)}'),
                      Text('Status: ${cop.status}'),
                    ],
                  ),
                  trailing: PopupMenuButton&lt;String&gt;(
                    onSelected: (action) => _handleCOPAction(context, cop, action),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      if (cop.status == 'Pending') ...[
                        const PopupMenuItem(value: 'approve', child: Text('Approve')),
                        const PopupMenuItem(value: 'reject', child: Text('Reject')),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddCOPDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => COPForm(projectId: widget.projectId),
    );
  }

  void _handleCOPAction(BuildContext context, COP cop, String action) {
    final appState = Provider.of&lt;AppState&gt;(context, listen: false);
    
    switch (action) {
      case 'edit':
        showDialog(
          context: context,
          builder: (context) => COPForm(cop: cop, projectId: widget.projectId),
        );
        break;
      case 'delete':
        appState.deleteCOP(cop.id);
        break;
      case 'approve':
        // Update COP status and budget head usage
        final updatedCOP = cop.copyWith(status: 'Approved');
        appState.updateCOP(updatedCOP);
        
        // Update budget head usage
        final project = appState.projects.firstWhere((p) => p.id == widget.projectId);
        final budgetHead = project.budgetHeads[cop.budgetHead];
        if (budgetHead != null) {
          budgetHead.updateUsedCost(budgetHead.usedCost + cop.amount);
        }
        break;
      case 'reject':
        appState.updateCOP(cop.copyWith(status: 'Rejected'));
        break;
    }
  }
}