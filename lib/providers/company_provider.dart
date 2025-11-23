import 'package:flutter/material.dart';
import 'package:workzen/models/company.dart';
import 'package:workzen/services/company_service.dart';

class CompanyProvider extends ChangeNotifier {
  final CompanyService _companyService = CompanyService();
  List<Company> _companies = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all companies
  Future<void> loadCompanies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _companies = await _companyService.getAllCompanies();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new company
  Future<String?> createCompany(Company company) async {
    try {
      final companyId = await _companyService.createCompany(company);
      await loadCompanies();
      return companyId;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Update company
  Future<bool> updateCompany(String companyId, Company company) async {
    try {
      await _companyService.updateCompany(companyId, company);
      await loadCompanies();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete company
  Future<bool> deleteCompany(String companyId) async {
    try {
      await _companyService.deleteCompany(companyId);
      await loadCompanies();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Toggle company status
  Future<bool> toggleCompanyStatus(String companyId, bool isActive) async {
    try {
      await _companyService.toggleCompanyStatus(companyId, isActive);
      await loadCompanies();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get company by ID
  Future<Company?> getCompanyById(String companyId) async {
    try {
      return await _companyService.getCompanyById(companyId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
