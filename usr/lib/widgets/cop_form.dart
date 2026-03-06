import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class COPForm extends StatefulWidget {
  final COP? cop;
  final String projectId;

  const COPForm({super.key, this.cop, required this.projectId});

  @override
  State&lt;COPForm&gt; createState() => _COPFormState();
}

class _COPFormState extends State&lt;COPForm&gt; {
  final _formKey = GlobalKey&lt;FormState&gt;();
  final _copNumberController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedVendor;
  String? _selectedBudgetHead;

  @override
  void initState() {
    super.initState();
    if (widget.cop != null) {
      _copNumberController.text = widget.cop!.copNumber;
      _amountController.text = widget.cop!.amount.toString();
      _selectedVendor = widget.cop!.vendorName;
      _selectedBudgetHead = widget.cop!.budgetHead;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final vendors = appState.vendors;
    final project = appState.projects.firstWhere((p) => p.id == widget.projectId);
    final budgetHeads = project.budgetHeads.keys.toList();

    return AlertDialog(
      title: Text(widget.cop == null ? 'Add COP' : 'Edit COP'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _copNumberController,
                decoration: const InputDecoration(labelText: 'COP Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField&lt;String&gt;(
                value: _selectedVendor,
                decoration: const InputDecoration(labelText: 'Vendor'),
                items: vendors.map((vendor) => 
                  DropdownMenuItem(value: vendor.name, child: Text(vendor.name))
                ).toList(),
                onChanged: (value) => setState(() => _selectedVendor = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              DropdownButtonFormField&lt;String&gt;(
                value: _selectedBudgetHead,
                decoration: const InputDecoration(labelText: 'Budget Head'),
                items: budgetHeads.map((head) => 
                  DropdownMenuItem(value: head, child: Text(head))
                ).toList(),
                onChanged: (value) => setState(() => _selectedBudgetHead = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  final amount = double.tryParse(value);
                  if (amount == null) return 'Invalid amount';
                  return null;
                },
              ),
              // Document Upload Section
              const SizedBox(height: 16),
              DocumentUploadWidget(recordId: widget.cop?.id ?? 'new', recordType: 'COP'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.cop == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of&lt;AppState&gt;(context, listen: false);
      final project = appState.projects.firstWhere((p) => p.id == widget.projectId);
      
      final cop = COP(
        id: widget.cop?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        copNumber: _copNumberController.text,
        vendorName: _selectedVendor!,
        projectId: widget.projectId,
        region: project.region,
        budgetHead: _selectedBudgetHead!,
        amount: double.parse(_amountController.text),
      );
      
      if (widget.cop == null) {
        appState.addCOP(cop);
      } else {
        appState.updateCOP(cop);
      }
      
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _copNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}