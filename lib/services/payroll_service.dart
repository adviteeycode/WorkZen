import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workzen/models/payslip.dart';

class PayrollService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'payslips';

  // Generate payslip
  Future<String> generatePayslip(Payslip payslip) async {
    try {
      final docRef = await _db.collection(_collection).add(payslip.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to generate payslip: $e');
    }
  }

  // Get payslip
  Future<Payslip?> getPayslip(String payslipId) async {
    try {
      final doc = await _db.collection(_collection).doc(payslipId).get();
      if (doc.exists) {
        return Payslip.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch payslip: $e');
    }
  }

  // Get payslips by user
  Future<List<Payslip>> getPayslipsByUser(String userId) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('year', descending: true)
          .orderBy('month', descending: true)
          .get();

      return query.docs
          .map((doc) => Payslip.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch payslips: $e');
    }
  }

  // Get payslips by company and month
  Future<List<Payslip>> getPayslipsByCompanyAndMonth(
    String companyId,
    int month,
    int year,
  ) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('companyId', isEqualTo: companyId)
          .where('month', isEqualTo: month)
          .where('year', isEqualTo: year)
          .get();

      return query.docs
          .map((doc) => Payslip.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch payslips: $e');
    }
  }

  // Update payslip
  Future<void> updatePayslip(String payslipId, Payslip payslip) async {
    try {
      await _db.collection(_collection).doc(payslipId).update(payslip.toMap());
    } catch (e) {
      throw Exception('Failed to update payslip: $e');
    }
  }

  // Update payslip status
  Future<void> updatePayslipStatus(
    String payslipId,
    PayrollStatus status,
  ) async {
    try {
      await _db.collection(_collection).doc(payslipId).update({
        'status': status.toString().split('.').last,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update payslip status: $e');
    }
  }

  // Get payslips by company
  Future<List<Payslip>> getPayslipsByCompany(String companyId) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('companyId', isEqualTo: companyId)
          .orderBy('year', descending: true)
          .orderBy('month', descending: true)
          .get();

      return query.docs
          .map((doc) => Payslip.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch payslips: $e');
    }
  }

  // Stream payslips by user
  Stream<List<Payslip>> getPayslipsStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Payslip.fromMap(doc.data(), doc.id))
              .toList();
        });
  }
}
