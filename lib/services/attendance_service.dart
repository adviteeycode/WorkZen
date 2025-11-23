import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workzen/models/attendance.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'attendance';

  // Mark attendance
  Future<String> markAttendance(Attendance attendance) async {
    try {
      final docRef = await _db.collection(_collection).add(attendance.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to mark attendance: $e');
    }
  }

  // Update attendance
  Future<void> updateAttendance(
    String attendanceId,
    Attendance attendance,
  ) async {
    try {
      await _db
          .collection(_collection)
          .doc(attendanceId)
          .update(attendance.toMap());
    } catch (e) {
      throw Exception('Failed to update attendance: $e');
    }
  }

  // Get attendance for date range
  Future<List<Attendance>> getAttendanceByUserAndDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      return query.docs
          .map((doc) => Attendance.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch attendance: $e');
    }
  }

  // Get today's attendance for user
  Future<Attendance?> getTodayAttendance(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final query = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      if (query.docs.isEmpty) return null;
      return Attendance.fromMap(query.docs.first.data(), query.docs.first.id);
    } catch (e) {
      throw Exception('Failed to fetch today attendance: $e');
    }
  }

  // Get monthly attendance
  Future<List<Attendance>> getMonthlyAttendance(
    String userId,
    int month,
    int year,
  ) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final query = await _db
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      return query.docs
          .map((doc) => Attendance.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch monthly attendance: $e');
    }
  }

  // Get attendance by company and date
  Future<List<Attendance>> getCompanyAttendanceByDate(
    String companyId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final query = await _db
          .collection(_collection)
          .where('companyId', isEqualTo: companyId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      return query.docs
          .map((doc) => Attendance.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch company attendance: $e');
    }
  }

  // Stream attendance for user in a month
  Stream<List<Attendance>> getMonthlyAttendanceStream(
    String userId,
    int month,
    int year,
  ) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);

    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Attendance.fromMap(doc.data(), doc.id))
              .toList();
        });
  }
}
