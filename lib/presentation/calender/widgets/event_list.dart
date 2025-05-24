import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventList extends StatelessWidget {
  final Map<DateTime, List<String>> events;
  final DateTime selectedDay;
  final VoidCallback onAddPressed;

  const EventList({
    required this.events,
    required this.selectedDay,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildEventItems(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            "Etkinlikler",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D40),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add_circle, color: Color(0xFF007965)),
            tooltip: 'Etkinlik Ekle',
          ),
        ],
      ),
    );
  }

  Widget _buildEventItems(BuildContext context) {
    final eventEntries = events.entries
        .where((entry) => isSameDay(entry.key, selectedDay))
        .expand((entry) => entry.value.map((e) => {
              'event': e,
              'date': entry.key,
            }))
        .toList();

    if (eventEntries.isEmpty) {
      return const Center(
        child: Text(
          "Bu gün için etkinlik yok.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: eventEntries.length,
      itemBuilder: (context, index) => _buildEventItem(
        context,
        eventEntries[index]['event'] as String,
        eventEntries[index]['date'] as DateTime,
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, String event, DateTime eventDate) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final int daysLeft = eventDate.difference(todayDate).inDays;
    final bool isUpcoming = daysLeft >= 0 && daysLeft <= 3;

    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F9F9),
        borderRadius: BorderRadius.circular(16),
        border: isUpcoming
            ? Border.all(color: Colors.teal, width: 2)
            : Border.all(color: const Color(0xFFB2DFDB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUpcoming)
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.teal, size: 18),
                const SizedBox(width: 6),
                Text(
                  daysLeft == 0
                      ? "Etkinlik bugün"
                      : "Etkinliğe $daysLeft gün kaldı",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          if (isUpcoming) const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.event_note, color: Color(0xFF00796B), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event,
                  style: const TextStyle(
                    color: Color(0xFF004D40),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFF00695C), size: 16),
              const SizedBox(width: 6),
              Text(
                DateFormat('d MMMM y', 'tr_TR').format(eventDate),
                style: const TextStyle(
                  color: Color(0xFF00695C),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
