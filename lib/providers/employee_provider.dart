import 'package:flutter/material.dart';
import 'package:workzen/models/user.dart';
import 'package:workzen/services/auth_service.dart';

class EmployeeProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentEmployee;
  List<User> _employees = [];
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentEmployee => _currentEmployee;
  List<User> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get employee by ID
  Future<void> getEmployeeById(String employeeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentEmployee = await _authService.getUserById(employeeId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all employees by company
  Future<void> getEmployeesByCompany(String companyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _employees = await _authService.getEmployeesByCompany(companyId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update employee
  Future<bool> updateEmployee(String employeeId, User updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.updateProfile(employeeId, updatedUser);
      _currentEmployee = updatedUser;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete employee
  Future<bool> deleteEmployee(String employeeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.deleteUser(employeeId);
      _employees.removeWhere((e) => e.userId == employeeId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear current employee
  void clearCurrentEmployee() {
    _currentEmployee = null;
    _errorMessage = null;
    notifyListeners();
  }
}
