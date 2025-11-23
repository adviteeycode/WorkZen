import 'package:flutter/material.dart';
import 'package:workzen/models/user.dart';
import 'package:workzen/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    required String companyName,
    String? companyId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
        companyName: companyName,
        companyId: companyId,
      );

      if (userId != null) {
        _currentUser = await _authService.getUserById(userId);
        _isLoggedIn = true;
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        return true;
      }
      _errorMessage = 'Login failed';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _errorMessage = null;
    _isInitialized = true;
    notifyListeners();
  }

  // Mark initialization complete (used when no user is logged in)
  void markInitialized() {
    _isInitialized = true;
    notifyListeners();
  }

  // Update profile
  Future<bool> updateProfile(User user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.updateProfile(user.userId, user);
      _currentUser = user;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
