import 'package:flutter/material.dart';
import 'package:workzen/models/payslip.dart';
import 'package:workzen/services/payroll_service.dart';

class PayrollProvider extends ChangeNotifier {
  final PayrollService _payrollService = PayrollService();

  List<Payslip> _payslipList = [];
  Payslip? _currentPayslip;
  bool _isLoading = false;
  String? _errorMessage;

  List<Payslip> get payslipList => _payslipList;
  Payslip? get currentPayslip => _currentPayslip;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get payslips by user
  Future<void> getPayslipsByUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payslipList = await _payrollService.getPayslipsByUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get payslip
  Future<void> getPayslip(String payslipId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentPayslip = await _payrollService.getPayslip(payslipId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generate payslip
  Future<bool> generatePayslip(Payslip payslip) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _payrollService.generatePayslip(payslip);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get payslips by company and month
  Future<void> getPayslipsByCompanyAndMonth(
    String companyId,
    int month,
    int year,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payslipList = await _payrollService.getPayslipsByCompanyAndMonth(
        companyId,
        month,
        year,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
