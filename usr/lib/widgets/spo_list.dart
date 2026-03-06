import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/spo_form.dart';
import '../widgets/vendor_summary_table.dart';

class SPOList extends StatefulWidget {
  final String projectId;

  const SPOList({super.key, required this.projectId});

  @override
  State&lt;SPOList&gt; createState() => _SPOListState();
}

class _SPOListState extends State&lt;SPOList&gt; {
  String _statusFilter = 'All';
  String _vendorFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final project = appState.projects.firstWhere((p) => p.id == widget.projectId);
    var spos = appState.getSPObyProject(widget.projectId);

    // Apply filters
    if (_statusFilter != 'All') {
      spos = spos.where((spo) => spo.status == _statusFilter).toList();
    }
    if (_vendorFilter != 'All') {
      spos = spos.where((spo) => spo.vendorName == _vendorFilter).toList();
    }

    return Column(
      children: [
        // Filters and Actions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField&lt;String&gt;(
                  value: _statusFilter,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['All', 'Pending', 'Approved', 'Rejected']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) => setState(() => _statusFilter = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField&lt;String&gt;(
                  value: _vendorFilter,
                  decoration: const InputDecoration(labelText: 'Vendor'),
                  items: ['All', ...appState.vendors.map((v) => v.name)]
                      .map((vendor) => DropdownMenuItem(value: vendor, child: Text(vendor)))
                      .toList(),
                  onChanged: (value) => setState(() => _vendorFilter = value!),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showAddSPODialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add SPO'),
              ),
            ],
          ),
        ),
        // Vendor Summary
        VendorSummaryTable(projectId: widget.projectId, type: 'SPO'),
        // SPO List
        Expanded(
          child: ListView.builder(
            itemCount: spos.length,
            itemBuilder: (context, index) {
              final spo = spos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text('SPO ${spo.spoNumber}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vendor: ${spo.vendorName}'),
                      Text('Amount: ₹${spo.amount.toStringAsFixed(2)}'),
                      Text('Status: ${spo.status}'),
                      if (spo.poNumber != null) Text('PO Number: ${spo.poNumber}'),
                      if (spo.approvedDate != null) Text('Approved Date: ${spo.approvedDate!.toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: PopupMenuButton&lt;String&gt;(
                    onSelected: (action) => _handleSPOAction(context, spo, action),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      if (spo.status == 'Pending') ...[
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

  void _showAddSPODialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SPOForm(projectId: widget.projectId),
    );
  }

  void _handleSPOAction(BuildContext context, SPO spo, String action) {
    final appState = Provider.of&lt;AppState&gt;(context, listen: false);
    
    switch (action) {
      case 'edit':
        showDialog(
          context: context,
          builder: (context) => SPOForm(spo: spo, projectId: widget.projectId),
        );
        break;
      case 'delete':
        appState.deleteSPO(spo.id);
        break;
      case 'approve':
        appState.updateSPO(spo.copyWith(status: 'Approved', approvedDate: DateTime.now()));
        break;
      case 'reject':
        appState.updateSPO(spo.copyWith(status: 'Rejected'));
        break;
    }
  }
}