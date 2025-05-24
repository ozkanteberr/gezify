import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';

class DestinationRepository {
  final FirebaseFirestore firestore;

  DestinationRepository({required this.firestore});

  Future<List<Destination>> fetchBestDestinations() async {
    final snapshot = await firestore
        .collection('destination')
        .where('isBestDestination', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => Destination.fromMap(doc.data())).toList();
  }

  Future<List<Destination>> getDestinationsByCategory(String category) async {
    try {
      final snapshot = await firestore
          .collection('destination')
          .where('categoryList', arrayContains: category)
          .where('isBestDestination', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => Destination.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Kategoriye göre veri alınamadı: $e');
    }
  }
}
