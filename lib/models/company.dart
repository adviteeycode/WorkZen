import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String companyId;
  final String companyName;
  final String? companyEmail;
  final String? companyPhone;
  final Address? address;
  final String? logo;
  final String? industry;
  final Subscription? subscription;
  final Settings? settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Company({
    required this.companyId,
    required this.companyName,
    this.companyEmail,
    this.companyPhone,
    this.address,
    this.logo,
    this.industry,
    this.subscription,
    this.settings,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory Company.fromMap(Map<String, dynamic> map, String id) {
    return Company(
      companyId: id,
      companyName: map['companyName'] ?? '',
      companyEmail: map['companyEmail'],
      companyPhone: map['companyPhone'],
      address: map['address'] != null ? Address.fromMap(map['address']) : null,
      logo: map['logo'],
      industry: map['industry'],
      subscription: map['subscription'] != null
          ? Subscription.fromMap(map['subscription'])
          : null,
      settings: map['settings'] != null
          ? Settings.fromMap(map['settings'])
          : null,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'companyEmail': companyEmail,
      'companyPhone': companyPhone,
      'address': address?.toMap(),
      'logo': logo,
      'industry': industry,
      'subscription': subscription?.toMap(),
      'settings': settings?.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  Company copyWith({
    String? companyId,
    String? companyName,
    String? companyEmail,
    String? companyPhone,
    Address? address,
    String? logo,
    String? industry,
    Subscription? subscription,
    Settings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Company(
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      companyEmail: companyEmail ?? this.companyEmail,
      companyPhone: companyPhone ?? this.companyPhone,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      industry: industry ?? this.industry,
      subscription: subscription ?? this.subscription,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;

  Address({this.street, this.city, this.state, this.country, this.zipCode});

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      zipCode: map['zipCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }
}

class Subscription {
  final String? plan;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
  final int? maxEmployees;

  Subscription({
    this.plan,
    this.startDate,
    this.endDate,
    this.isActive,
    this.maxEmployees,
  });

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      plan: map['plan'],
      startDate: map['startDate']?.toDate(),
      endDate: map['endDate']?.toDate(),
      isActive: map['isActive'],
      maxEmployees: map['maxEmployees'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'plan': plan,
      'isActive': isActive,
      'maxEmployees': maxEmployees,
    };
    // Only include dates if they're not null
    if (startDate != null) map['startDate'] = startDate;
    if (endDate != null) map['endDate'] = endDate;
    return map;
  }
}

class Settings {
  final String? payrollCycle;
  final String? workingDays;
  final double? pfRate;
  final double? ptRate;
  final String? currency;

  Settings({
    this.payrollCycle,
    this.workingDays,
    this.pfRate,
    this.ptRate,
    this.currency,
  });

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      payrollCycle: map['payrollCycle'],
      workingDays: map['workingDays'],
      pfRate: (map['pfRate'] as num?)?.toDouble(),
      ptRate: (map['ptRate'] as num?)?.toDouble(),
      currency: map['currency'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payrollCycle': payrollCycle,
      'workingDays': workingDays,
      'pfRate': pfRate,
      'ptRate': ptRate,
      'currency': currency,
    };
  }
}
