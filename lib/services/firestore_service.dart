import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blood_request_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Create request
  Future<void> createRequest(BloodRequest request) async {
    await _db.collection('requests').doc(request.id).set(request.toMap());
  }

  // Get all open requests (real-time)
  Stream<List<BloodRequest>> getRequests() {
    return _db
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => BloodRequest.fromMap(d.data())).toList(),
        );
  }

  // Mark fulfilled
  Future<void> markFulfilled(String requestId) async {
    await _db.collection('requests').doc(requestId).update({
      'isFulfilled': true,
    });
  }

  // Delete request
  Future<void> deleteRequest(String requestId) async {
    await _db.collection('requests').doc(requestId).delete();
  }
}
