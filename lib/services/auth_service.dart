import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workzen/models/user.dart';

class AuthService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Register new user
  Future<String?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    required String companyName,
    String? companyId,
  }) async {
    try {
      // Check if email already exists
      final existing = await _db
          .collection(_collection)
          .where('email', isEqualTo: email)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('Email already registered');
      }

      // Create or get company
      String finalCompanyId = companyId ?? '';
      if (finalCompanyId.isEmpty) {
        // Create new company if not provided
        final companyDoc = await _db.collection('companies').add({
          'name': companyName,
          'createdAt': Timestamp.fromDate(DateTime.now()),
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
        finalCompanyId = companyDoc.id;
      }

      final user = User(
        userId: '', // Will be set by Firestore
        email: email,
        password: password, // In production, hash this!
        firstName: firstName,
        lastName: lastName,
        role: role,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        companyId: finalCompanyId,
      );

      final docRef = await _db.collection(_collection).add(user.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Login user
  Future<User?> login(String email, String password) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Invalid email or password');
      }

      final doc = query.docs.first;
      return User.fromMap(doc.data(), doc.id);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Get user by ID
  Future<User?> getUserById(String userId) async {
    try {
      final doc = await _db.collection(_collection).doc(userId).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile(String userId, User user) async {
    try {
      await _db.collection(_collection).doc(userId).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get all employees by company
  Future<List<User>> getEmployeesByCompany(String companyId) async {
    try {
      final query = await _db
          .collection(_collection)
          .where('companyId', isEqualTo: companyId)
          .where('role', isEqualTo: 'employee')
          .get();

      return query.docs.map((doc) => User.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }

  // Get all users by company and role
  Future<List<User>> getUsersByCompanyAndRole(
    String companyId,
    UserRole role,
  ) async {
    try {
      final roleString = role.toString().split('.').last;
      final query = await _db
          .collection(_collection)
          .where('companyId', isEqualTo: companyId)
          .where('role', isEqualTo: roleString)
          .get();

      return query.docs.map((doc) => User.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Stream users by company
  Stream<List<User>> getUsersStream(String companyId) {
    return _db
        .collection(_collection)
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => User.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection(_collection).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
