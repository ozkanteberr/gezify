import 'package:flutter/material.dart';
import 'package:gezify/presentation/calander/model/event_model.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  final EventModel event;

  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.event_note, color: Colors.teal),
        title: Text(event.title),
        subtitle: Text(DateFormat.yMMMMd('tr_TR').format(event.date)),
      ),
    );
  }
}
