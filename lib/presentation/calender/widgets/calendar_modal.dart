import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarModal extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onPageChanged;

  const CalendarModal({
    Key? key,
    required this.initialDate,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  _CalendarModalState createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color(0xFFF1F9F9), // Tema arka planı
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020),
                  lastDay: DateTime.utc(2030),
                  focusedDay: _focusedDay,
                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(
                      color: Color(0xFF004D40),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF007965)),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF007965)),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Color(0xFF004D40)),
                    weekendTextStyle: const TextStyle(color: Color(0xFF007965)),
                    outsideTextStyle: const TextStyle(color: Colors.grey),
                    todayTextStyle: const TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF007965),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF004D40),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Color(0xFF007965)),
                    weekendStyle: TextStyle(color: Color(0xFF007965)),
                  ),
                  onPageChanged: (focusedDay) {
                    setState(() => _focusedDay = focusedDay);
                    widget.onPageChanged(focusedDay);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
