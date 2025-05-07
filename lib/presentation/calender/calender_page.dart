import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<DateTime, String> _meetingStatus = {
    DateTime.utc(2023, 8, 5): 'past',
    DateTime.utc(2023, 8, 8): 'cancelled',
    DateTime.utc(2023, 8, 14): 'past',
    DateTime.utc(2023, 8, 18): 'today',
    DateTime.utc(2023, 8, 22): 'cancelled',
    DateTime.utc(2023, 8, 31): 'upcoming',
  };

  Map<DateTime, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  void _addEventDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Etkinlik Ekle"),
        content: TextField(
          controller: _eventController,
          decoration: const InputDecoration(hintText: "Etkinlik adı girin"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _eventController.clear();
            },
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              if (_eventController.text.isEmpty) return;
              setState(() {
                final selected = DateTime.utc(date.year, date.month, date.day);
                if (_events[selected] != null) {
                  _events[selected]!.add(_eventController.text);
                } else {
                  _events[selected] = [_eventController.text];
                }
              });
              _eventController.clear();
              Navigator.pop(context);
            },
            child: const Text("Ekle"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Check my Calendar", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: true,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              leftChevronVisible: true,
              rightChevronVisible: true,
              leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
              rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final status = _meetingStatus[DateTime.utc(day.year, day.month, day.day)];
                Color? bgColor;

                switch (status) {
                  case 'today':
                    bgColor = Colors.blue.shade700;
                    break;
                  case 'past':
                    bgColor = Colors.purple.shade200;
                    break;
                  case 'cancelled':
                    bgColor = Colors.pink.shade100;
                    break;
                  case 'upcoming':
                    bgColor = Colors.orange.shade100;
                    break;
                  default:
                    bgColor = null;
                }

                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _buildLegend(Colors.blue.shade700, "Today's Date"),
                _buildLegend(Colors.pink.shade100, "Cancelled Meetings"),
                _buildLegend(Colors.purple.shade200, "Past Meetings"),
                _buildLegend(Colors.orange.shade100, "Upcoming Meetings"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedDay != null && _events[DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] != null)
            ..._events[DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)]!.map((event) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(event)),
                ],
              ),
            )),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () {
                if (_selectedDay != null) {
                  _addEventDialog(_selectedDay!);
                }
              },
              child: const Text("Etkinlik Ekle", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(backgroundColor: color, radius: 6),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
