import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, employee, hrOfficer, payrollOfficer }

class User {
  final String userId;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? profilePicture;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? companyId;
  final double? basicSalary;
  final double? pfRate;
  final double? ptRate;
  final String? bankAccount;
  final String? bankName;
  final String? ifscCode;

  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.profilePicture,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.companyId,
    this.basicSalary,
    this.pfRate,
    this.ptRate,
    this.bankAccount,
    this.bankName,
    this.ifscCode,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      userId: id,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
      profilePicture: map['profilePicture'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${map['role']}',
        orElse: () => UserRole.employee,
      ),
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
      companyId: map['companyId'],
      basicSalary: (map['basicSalary'] as num?)?.toDouble(),
      pfRate: (map['pfRate'] as num?)?.toDouble(),
      ptRate: (map['ptRate'] as num?)?.toDouble(),
      bankAccount: map['bankAccount'],
      bankName: map['bankName'],
      ifscCode: map['ifscCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'profilePicture': profilePicture,
      'role': role.toString().split('.').last,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'companyId': companyId,
      'basicSalary': basicSalary,
      'pfRate': pfRate,
      'ptRate': ptRate,
      'bankAccount': bankAccount,
      'bankName': bankName,
      'ifscCode': ifscCode,
    };
  }

  User copyWith({
    String? userId,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? profilePicture,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? companyId,
    double? basicSalary,
    double? pfRate,
    double? ptRate,
    String? bankAccount,
    String? bankName,
    String? ifscCode,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      companyId: companyId ?? this.companyId,
      basicSalary: basicSalary ?? this.basicSalary,
      pfRate: pfRate ?? this.pfRate,
      ptRate: ptRate ?? this.ptRate,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      ifscCode: ifscCode ?? this.ifscCode,
    );
  }
}
