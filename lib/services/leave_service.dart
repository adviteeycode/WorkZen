import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workzen/models/leave.dart';

class LeaveService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'leaves';

  // Apply for leave
  Future<String> applyLeave(Leave leave) async {
    try {
      final docRef = await _db.collection(_collection).add(leave.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to apply leave: $e');
    }
  }

  // Approve leave
  Future<void> approveLeave(
    String leaveId,
    String approvedBy, {
    String? comment,
  }) async {
    try {
      await _db.collection(_collection).doc(leaveId).update({
        'status': 'approved',
        'approvedBy': approvedBy,
        'approverComment': comment,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to approve leave: $e');
    }
  }

  // Reject leave
  Future<void> rejectLeave(
    String leaveId,
    String approvedBy, {
    String? comment,
  }) async {
    try {
      await _db.collection(_collection).doc(leaveId).update({
        'status': 'rejected',
        'approvedBy': approvedBy,
        'approverComment': comment,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to reject leave: $e');
    }
  }

  // Get leaves by user
  Future<List<Leave>> getLeavesByUser(String userId) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      return query.docs
          .map((doc) => Leave.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leaves: $e');
    }
  }

  // Get pending leaves for approval
  Future<List<Leave>> getPendingLeaves(String companyId) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('companyId', isEqualTo: companyId)
          .where('status', isEqualTo: 'pending')
          .get();

      return query.docs
          .map((doc) => Leave.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pending leaves: $e');
    }
  }

  // Get all leaves by company
  Future<List<Leave>> getLeavesByCompany(String companyId) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('companyId', isEqualTo: companyId)
          .get();

      return query.docs
          .map((doc) => Leave.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leaves: $e');
    }
  }

  // Stream pending leaves
  Stream<List<Leave>> getPendingLeavesStream(String companyId) {
    return _db
        .collection(_collection)
        .where('companyId', isEqualTo: companyId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Leave.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Cancel leave
  Future<void> cancelLeave(String leaveId) async {
    try {
      await _db.collection(_collection).doc(leaveId).update({
        'status': 'cancelled',
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to cancel leave: $e');
    }
  }
}
