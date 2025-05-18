import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String destinationId;
  final String userName;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.destinationId,
    required this.userName,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      destinationId: map['destinationId'],
      userName: map['userName'],
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destinationId': destinationId,
      'userName': userName,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
