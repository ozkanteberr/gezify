class EventModel {
  final String id;
  final String title;
  final DateTime date;

  EventModel({required this.id, required this.title, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
    );
  }
}
