import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, absent, halfDay, leaveApproved, leaveRejected }

class Attendance {
  final String attendanceId;
  final String userId;
  final String companyId;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;
  final double? workingHours;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Attendance({
    required this.attendanceId,
    required this.userId,
    required this.companyId,
    required this.date,
    required this.status,
    this.notes,
    this.workingHours,
    this.checkInTime,
    this.checkOutTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attendance.fromMap(Map<String, dynamic> map, String id) {
    return Attendance(
      attendanceId: id,
      userId: map['userId'] ?? '',
      companyId: map['companyId'] ?? '',
      date: map['date']?.toDate() ?? DateTime.now(),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${map['status']}',
        orElse: () => AttendanceStatus.absent,
      ),
      notes: map['notes'],
      workingHours: (map['workingHours'] as num?)?.toDouble(),
      checkInTime: map['checkInTime']?.toDate(),
      checkOutTime: map['checkOutTime']?.toDate(),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'companyId': companyId,
      'date': Timestamp.fromDate(date),
      'status': status.toString().split('.').last,
      'notes': notes,
      'workingHours': workingHours,
      'checkInTime': checkInTime != null
          ? Timestamp.fromDate(checkInTime!)
          : null,
      'checkOutTime': checkOutTime != null
          ? Timestamp.fromDate(checkOutTime!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
