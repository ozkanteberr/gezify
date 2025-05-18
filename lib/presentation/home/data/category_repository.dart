import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<String>> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs
          .where((doc) => doc.data().containsKey('label'))
          .map((doc) => doc['label'] as String)
          .toList();
    } catch (e) {
      print('Kategori verileri alınamadı: $e');
      return [];
    }
  }
}
