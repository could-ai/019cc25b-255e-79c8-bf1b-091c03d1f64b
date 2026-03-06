import 'package:flutter/material.dart';
import '../widgets/document_upload_widget.dart';

extension SPOCopyWith on SPO {
  SPO copyWith({
    String? id,
    String? spoNumber,
    String? vendorName,
    String? projectId,
    String? region,
    double? amount,
    String? status,
    String? poNumber,
    double? poAmount,
    DateTime? approvedDate,
  }) {
    return SPO(
      id: id ?? this.id,
      spoNumber: spoNumber ?? this.spoNumber,
      vendorName: vendorName ?? this.vendorName,
      projectId: projectId ?? this.projectId,
      region: region ?? this.region,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      poNumber: poNumber ?? this.poNumber,
      poAmount: poAmount ?? this.poAmount,
      approvedDate: approvedDate ?? this.approvedDate,
    );
  }
}

extension COPCopyWith on COP {
  COP copyWith({
    String? id,
    String? copNumber,
    String? vendorName,
    String? projectId,
    String? region,
    String? budgetHead,
    double? amount,
    String? status,
  }) {
    return COP(
      id: id ?? this.id,
      copNumber: copNumber ?? this.copNumber,
      vendorName: vendorName ?? this.vendorName,
      projectId: projectId ?? this.projectId,
      region: region ?? this.region,
      budgetHead: budgetHead ?? this.budgetHead,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }
}