import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventModal extends StatefulWidget {
  final TextEditingController controller;
  final Function(String, DateTime, DateTime) onSave;

  const EventModal({
    Key? key,
    required this.controller,
    required this.onSave,
  }) : super(key: key);

  @override
  _EventModalState createState() => _EventModalState();
}

class _EventModalState extends State<EventModal> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = selectedDay;
        _rangeEnd = null;
      } else if (_rangeStart != null && _rangeEnd == null) {
        if (selectedDay.isBefore(_rangeStart!)) {
          _rangeEnd = _rangeStart;
          _rangeStart = selectedDay;
        } else {
          _rangeEnd = selectedDay;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF1F9F9), // açık arka plan
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Etkinlik Tarihlerini Seç",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D40), // koyu yeşil
              ),
            ),
            const SizedBox(height: 12),
            TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),
              focusedDay: _focusedDay,
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() => _focusedDay = focusedDay);
                _onDaySelected(selectedDay);
              },
              calendarStyle: CalendarStyle(
                rangeStartDecoration: const BoxDecoration(
                  color: Color(0xFF007965), // tema yeşili
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: const BoxDecoration(
                  color: Color(0xFF007965),
                  shape: BoxShape.circle,
                ),
                withinRangeDecoration: BoxDecoration(
                  color: const Color(0xFFB2DFDB), // açık yeşil
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(color: Color(0xFF004D40)),
                weekendTextStyle: const TextStyle(color: Color(0xFF00695C)),
                outsideTextStyle: const TextStyle(color: Colors.grey),
                todayDecoration: const BoxDecoration(
                  color: Color(0xFF80CBC4),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFF007965),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
              ),
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(color: Color(0xFF004D40), fontSize: 16),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF004D40)),
                rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF004D40)),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Color(0xFF00796B)),
                weekendStyle: TextStyle(color: Color(0xFF00796B)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.controller,
              style: const TextStyle(color: Color(0xFF004D40)),
              decoration: InputDecoration(
                labelText: 'Etkinlik Adı',
                labelStyle: const TextStyle(color: Color(0xFF004D40)),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFB2DFDB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF007965), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007965),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                if (widget.controller.text.isEmpty ||
                    _rangeStart == null ||
                    _rangeEnd == null) return;

                widget.onSave(
                  widget.controller.text,
                  _rangeStart!,
                  _rangeEnd!,
                );
                widget.controller.clear();
                Navigator.pop(context);
              },
              child: const Text('Etkinliği Oluştur', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
