import 'package:cloud_firestore/cloud_firestore.dart';

enum PayrollStatus { draft, processed, paid, failed }

class Payslip {
  final String payslipId;
  final String userId;
  final String companyId;
  final int month;
  final int year;
  final double basicSalary;
  final double daysWorked;
  final double grossSalary;
  final double pfDeduction;
  final double ptDeduction;
  final double otherDeductions;
  final double netSalary;
  final PayrollStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payslip({
    required this.payslipId,
    required this.userId,
    required this.companyId,
    required this.month,
    required this.year,
    required this.basicSalary,
    required this.daysWorked,
    required this.grossSalary,
    required this.pfDeduction,
    required this.ptDeduction,
    required this.otherDeductions,
    required this.netSalary,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payslip.fromMap(Map<String, dynamic> map, String id) {
    return Payslip(
      payslipId: id,
      userId: map['userId'] ?? '',
      companyId: map['companyId'] ?? '',
      month: map['month'] ?? 1,
      year: map['year'] ?? 2025,
      basicSalary: (map['basicSalary'] as num?)?.toDouble() ?? 0.0,
      daysWorked: (map['daysWorked'] as num?)?.toDouble() ?? 0.0,
      grossSalary: (map['grossSalary'] as num?)?.toDouble() ?? 0.0,
      pfDeduction: (map['pfDeduction'] as num?)?.toDouble() ?? 0.0,
      ptDeduction: (map['ptDeduction'] as num?)?.toDouble() ?? 0.0,
      otherDeductions: (map['otherDeductions'] as num?)?.toDouble() ?? 0.0,
      netSalary: (map['netSalary'] as num?)?.toDouble() ?? 0.0,
      status: PayrollStatus.values.firstWhere(
        (e) => e.toString() == 'PayrollStatus.${map['status']}',
        orElse: () => PayrollStatus.draft,
      ),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'companyId': companyId,
      'month': month,
      'year': year,
      'basicSalary': basicSalary,
      'daysWorked': daysWorked,
      'grossSalary': grossSalary,
      'pfDeduction': pfDeduction,
      'ptDeduction': ptDeduction,
      'otherDeductions': otherDeductions,
      'netSalary': netSalary,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
