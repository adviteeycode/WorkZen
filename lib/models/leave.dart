import 'package:cloud_firestore/cloud_firestore.dart';

enum LeaveType { sick, casual, personal, earned, unpaid }

enum LeaveStatus { pending, approved, rejected, cancelled }

class Leave {
  final String leaveId;
  final String userId;
  final String companyId;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfDays;
  final String? reason;
  final LeaveStatus status;
  final String? approverComment;
  final String? approvedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Leave({
    required this.leaveId,
    required this.userId,
    required this.companyId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    this.reason,
    required this.status,
    this.approverComment,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Leave.fromMap(Map<String, dynamic> map, String id) {
    return Leave(
      leaveId: id,
      userId: map['userId'] ?? '',
      companyId: map['companyId'] ?? '',
      leaveType: LeaveType.values.firstWhere(
        (e) => e.toString() == 'LeaveType.${map['leaveType']}',
        orElse: () => LeaveType.casual,
      ),
      startDate: map['startDate']?.toDate() ?? DateTime.now(),
      endDate: map['endDate']?.toDate() ?? DateTime.now(),
      numberOfDays: map['numberOfDays'] ?? 0,
      reason: map['reason'],
      status: LeaveStatus.values.firstWhere(
        (e) => e.toString() == 'LeaveStatus.${map['status']}',
        orElse: () => LeaveStatus.pending,
      ),
      approverComment: map['approverComment'],
      approvedBy: map['approvedBy'],
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'companyId': companyId,
      'leaveType': leaveType.toString().split('.').last,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'numberOfDays': numberOfDays,
      'reason': reason,
      'status': status.toString().split('.').last,
      'approverComment': approverComment,
      'approvedBy': approvedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
