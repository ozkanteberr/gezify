import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gezify/presentation/calander/model/event_model.dart';

class EventRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get currentUserId => _auth.currentUser!.uid;

  Future<void> addEvent(EventModel event) async {
    await _firestore
        .collection('userEvents')
        .doc(currentUserId)
        .collection('events')
        .doc(event.id)
        .set(event.toMap());
  }

  Stream<List<EventModel>> getEvents() {
    return _firestore
        .collection('userEvents')
        .doc(currentUserId)
        .collection('events')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventModel.fromMap(doc.data()))
            .toList());
  }
}
