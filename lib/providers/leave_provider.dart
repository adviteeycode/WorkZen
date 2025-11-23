import 'package:flutter/material.dart';
import 'package:workzen/models/leave.dart';
import 'package:workzen/services/leave_service.dart';

class LeaveProvider extends ChangeNotifier {
  final LeaveService _leaveService = LeaveService();

  List<Leave> _leaveList = [];
  List<Leave> _pendingLeaves = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Leave> get leaveList => _leaveList;
  List<Leave> get pendingLeaves => _pendingLeaves;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Apply for leave
  Future<bool> applyLeave(Leave leave) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _leaveService.applyLeave(leave);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get leaves by user
  Future<void> getLeavesByUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _leaveList = await _leaveService.getLeavesByUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get pending leaves
  Future<void> getPendingLeaves(String companyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pendingLeaves = await _leaveService.getPendingLeaves(companyId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Approve leave
  Future<bool> approveLeave(
    String leaveId,
    String approvedBy, {
    String? comment,
  }) async {
    try {
      await _leaveService.approveLeave(leaveId, approvedBy, comment: comment);
      await getPendingLeaves(_pendingLeaves.first.companyId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Reject leave
  Future<bool> rejectLeave(
    String leaveId,
    String approvedBy, {
    String? comment,
  }) async {
    try {
      await _leaveService.rejectLeave(leaveId, approvedBy, comment: comment);
      await getPendingLeaves(_pendingLeaves.first.companyId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
