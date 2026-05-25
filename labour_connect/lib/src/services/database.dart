import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/posting.dart';

class DatabaseMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Users ──────────────────────────────────────────────────────────────────

  Future<void> addUserInfo(Map<String, dynamic> userData, String id) async {
    await _db
        .collection('users')
        .doc(id)
        .set(userData)
        .catchError((e) => print('addUserInfo error: $e'));
  }

  Future getUserInfo(String email) async {
    return _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .catchError((e) => print('getUserInfo error: $e'));
  }

  // ── Postings ───────────────────────────────────────────────────────────────

  /// Add a new posting (company need OR labour availability).
  Future<void> addPosting(Map<String, dynamic> postingData) async {
    await _db
        .collection('postings')
        .add(postingData)
        .catchError((e) => print('addPosting error: $e'));
  }

  /// Live stream of ALL postings, newest first.
  /// Used by the main feed screen.
  Stream<QuerySnapshot> getAllPostings() {
    return _db
        .collection('postings')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Live stream filtered by type: 'company' or 'labour'.
  Stream<QuerySnapshot> getPostingsByType(String type) {
    return _db
        .collection('postings')
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Live stream of urgent postings only.
  Stream<QuerySnapshot> getUrgentPostings() {
    return _db
        .collection('postings')
        .where('urgent', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// All postings created by the logged-in user (for Profile / My Posts).
  Stream<QuerySnapshot> getMyPostings(String uid) {
    return _db
        .collection('postings')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Delete a posting by its Firestore document ID.
  Future<void> deletePosting(String postingId) async {
    await _db
        .collection('postings')
        .doc(postingId)
        .delete()
        .catchError((e) => print('deletePosting error: $e'));
  }

  /// Update an existing posting.
  Future<void> updatePosting(
      String postingId, Map<String, dynamic> data) async {
    await _db
        .collection('postings')
        .doc(postingId)
        .update(data)
        .catchError((e) => print('updatePosting error: $e'));
  }
}
