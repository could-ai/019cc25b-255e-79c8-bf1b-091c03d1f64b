import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SPOForm extends StatefulWidget {
  final SPO? spo;
  final String projectId;

  const SPOForm({super.key, this.spo, required this.projectId});

  @override
  State&lt;SPOForm&gt; createState() => _SPOFormState();
}

class _SPOFormState extends State&lt;SPOForm&gt; {
  final _formKey = GlobalKey&lt;FormState&gt;();
  final _spoNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _poNumberController = TextEditingController();
  final _poAmountController = TextEditingController();
  String? _selectedVendor;
  DateTime? _approvedDate;

  @override
  void initState() {
    super.initState();
    if (widget.spo != null) {
      _spoNumberController.text = widget.spo!.spoNumber;
      _amountController.text = widget.spo!.amount.toString();
      _selectedVendor = widget.spo!.vendorName;
      _poNumberController.text = widget.spo!.poNumber ?? '';
      _poAmountController.text = widget.spo!.poAmount?.toString() ?? '';
      _approvedDate = widget.spo!.approvedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of&lt;AppState&gt;(context);
    final vendors = appState.vendors;
    final project = appState.projects.firstWhere((p) => p.id == widget.projectId);

    return AlertDialog(
      title: Text(widget.spo == null ? 'Add SPO' : 'Edit SPO'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _spoNumberController,
                decoration: const InputDecoration(labelText: 'SPO Number'),
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
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  final amount = double.tryParse(value);
                  if (amount == null) return 'Invalid amount';
                  
                  // Check PO amount limit
                  if (_selectedVendor != null && _poAmountController.text.isNotEmpty) {
                    final poAmount = double.tryParse(_poAmountController.text);
                    if (poAmount != null) {
                      final vendor = vendors.firstWhere((v) => v.name == _selectedVendor);
                      final totalSPOForVendor = appState.getSPObyProject(widget.projectId)
                          .where((spo) => spo.vendorName == _selectedVendor && spo.id != widget.spo?.id)
                          .fold(0.0, (sum, spo) => sum + spo.amount);
                      if (totalSPOForVendor + amount > poAmount) {
                        return 'Total SPO amount exceeds the PO amount for this vendor.';
                      }
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _poNumberController,
                decoration: const InputDecoration(labelText: 'PO Number (Optional)'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _poAmountController,
                decoration: const InputDecoration(labelText: 'PO Amount (Optional)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              // Document Upload Section
              const SizedBox(height: 16),
              DocumentUploadWidget(recordId: widget.spo?.id ?? 'new', recordType: 'SPO'),
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
          child: Text(widget.spo == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of&lt;AppState&gt;(context, listen: false);
      final project = appState.projects.firstWhere((p) => p.id == widget.projectId);
      
      final spo = SPO(
        id: widget.spo?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        spoNumber: _spoNumberController.text,
        vendorName: _selectedVendor!,
        projectId: widget.projectId,
        region: project.region,
        amount: double.parse(_amountController.text),
        poNumber: _poNumberController.text.isEmpty ? null : _poNumberController.text,
        poAmount: _poAmountController.text.isEmpty ? null : double.parse(_poAmountController.text),
        approvedDate: _approvedDate,
      );
      
      if (widget.spo == null) {
        appState.addSPO(spo);
      } else {
        appState.updateSPO(spo);
      }
      
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _spoNumberController.dispose();
    _amountController.dispose();
    _poNumberController.dispose();
    _poAmountController.dispose();
    super.dispose();
  }
}