import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workzen/models/company.dart';

class CompanyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'companies';

  // Create a new company
  Future<String> createCompany(Company company) async {
    try {
      final docRef = await _db.collection(_collection).add(company.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create company: $e');
    }
  }

  // Get all companies
  Future<List<Company>> getAllCompanies() async {
    try {
      final snapshot = await _db.collection(_collection).get();
      return snapshot.docs
          .map((doc) => Company.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch companies: $e');
    }
  }

  // Get company by ID
  Future<Company?> getCompanyById(String companyId) async {
    try {
      final doc = await _db.collection(_collection).doc(companyId).get();
      if (doc.exists) {
        return Company.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch company: $e');
    }
  }

  // Update company
  Future<void> updateCompany(String companyId, Company company) async {
    try {
      await _db.collection(_collection).doc(companyId).update(company.toMap());
    } catch (e) {
      throw Exception('Failed to update company: $e');
    }
  }

  // Delete company
  Future<void> deleteCompany(String companyId) async {
    try {
      await _db.collection(_collection).doc(companyId).delete();
    } catch (e) {
      throw Exception('Failed to delete company: $e');
    }
  }

  // Activate/Deactivate company
  Future<void> toggleCompanyStatus(String companyId, bool isActive) async {
    try {
      await _db.collection(_collection).doc(companyId).update({
        'isActive': isActive,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to update company status: $e');
    }
  }

  // Stream of all companies
  Stream<List<Company>> getCompaniesStream() {
    return _db.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Company.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
