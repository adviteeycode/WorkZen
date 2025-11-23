import 'package:flutter/material.dart';
import 'package:workzen/models/attendance.dart';
import 'package:workzen/services/attendance_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _attendanceService = AttendanceService();

  List<Attendance> _attendanceList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Attendance> get attendanceList => _attendanceList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mark attendance
  Future<bool> markAttendance(Attendance attendance) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _attendanceService.markAttendance(attendance);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get monthly attendance
  Future<void> getMonthlyAttendance(String userId, int month, int year) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _attendanceList = await _attendanceService.getMonthlyAttendance(
        userId,
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

  // Get today attendance
  Future<Attendance?> getTodayAttendance(String userId) async {
    try {
      return await _attendanceService.getTodayAttendance(userId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
