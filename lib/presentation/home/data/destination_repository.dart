import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';

class DestinationRepository {
  final FirebaseFirestore firestore;

  DestinationRepository({required this.firestore});

  Future<List<Destination>> fetchBestDestinations() async {
    final snapshot = await firestore
        .collection('bestDestination')
        .where('isBestDestination', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => Destination.fromMap(doc.data())).toList();
  }
}
