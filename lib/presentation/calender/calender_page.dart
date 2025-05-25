import 'package:flutter/material.dart';
import 'package:gezify/presentation/calender/widget/calendar_modal.dart';
import 'package:gezify/presentation/calender/widget/event_list.dart';
import 'package:gezify/presentation/calender/widget/event_modal.dart';
import 'package:gezify/presentation/calender/widget/week_days_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  void _handleEventCreated(String event, DateTime start, DateTime end) {
    DateTime current = start;
    while (!current.isAfter(end)) {
      final key = DateTime.utc(current.year, current.month, current.day);
      setState(() {
        _events[key] = [..._events[key] ?? [], event];
      });
      current = current.add(const Duration(days: 1));
    }
  }

  void _openCalendarModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF1F9F9), // Hafif yeşilimsi beyaz
      builder: (_) => CalendarModal(
        initialDate: _focusedDay,
        onPageChanged: (day) => setState(() => _focusedDay = day),
      ),
    );
  }

  void _openEventModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Hafif yeşilimsi beyaz
      builder: (_) => EventModal(
        controller: _eventController,
        onSave: _handleEventCreated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1), // Açık arka plan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Etkinlik ve Takvim Sayfam",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D40), // Koyu yeşil başlık
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF007965)), // Tema yeşili
            onPressed: _openCalendarModal,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 10),
          WeekDaysPicker(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (day) => setState(() => _selectedDay = day),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: EventList(
              events: _events,
              selectedDay: _selectedDay ?? _focusedDay,
              onAddPressed: _openEventModal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.MMMM('tr_TR').format(_focusedDay).toUpperCase(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D40), // Koyu yeşil
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd MMMM yyyy', 'tr_TR').format(DateTime.now()),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF007965), // Tema yeşili
            ),
          ),
        ],
      ),
    );
  }
}
