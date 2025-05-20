import 'package:flutter/material.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final Map<DateTime, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  void _openDatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2C2E),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Takvim",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 12),
              TableCalendar(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030),
                focusedDay: _focusedDay,
                selectedDayPredicate: (_) => false, // Hiçbir gün seçili olmasın
                onDaySelected:
                    (_, __) {}, // Gün seçilince hiçbir işlem yapılmasın
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  outsideTextStyle: const TextStyle(color: Colors.grey),
                  todayTextStyle: const TextStyle(
                      color: Colors.black), // Bugün yazısı siyah
                  todayDecoration: BoxDecoration(
                    color: Colors.yellowAccent, // Bugün sarı zemin
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.white),
                  formatButtonVisible: false,
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.white),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white70),
                  weekendStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCalendarModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            DateTime modalFocusedDay = _focusedDay;

            void onDaySelected(DateTime selectedDay) {
              setModalState(() {
                if (_rangeStart == null ||
                    (_rangeStart != null && _rangeEnd != null)) {
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

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Etkinlik Tarihlerini Seç",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: modalFocusedDay,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) => (_rangeStart != null &&
                        _rangeEnd != null &&
                        day.isAfter(
                            _rangeStart!.subtract(const Duration(days: 1))) &&
                        day.isBefore(_rangeEnd!.add(const Duration(days: 1)))),
                    onDaySelected: (selectedDay, _) {
                      onDaySelected(selectedDay);
                    },
                    calendarStyle: CalendarStyle(
                      rangeStartDecoration: const BoxDecoration(
                        color: Colors.yellowAccent,
                        shape: BoxShape.circle,
                      ),
                      rangeEndDecoration: const BoxDecoration(
                        color: Colors.yellowAccent,
                        shape: BoxShape.circle,
                      ),
                      withinRangeDecoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: const TextStyle(color: Colors.white),
                      weekendTextStyle: const TextStyle(color: Colors.white70),
                      outsideTextStyle: const TextStyle(color: Colors.grey),
                      todayDecoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.yellowAccent,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(color: Colors.black),
                    ),
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(color: Colors.white),
                      formatButtonVisible: false,
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.white),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.white),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.white70),
                      weekendStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _eventController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Etkinlik Adı',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.yellowAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      if (_eventController.text.isEmpty ||
                          _rangeStart == null ||
                          _rangeEnd == null) return;

                      DateTime current = _rangeStart!;
                      while (!current.isAfter(_rangeEnd!)) {
                        final key = DateTime(current.year, current.month, current.day);
                        setState(() {
                          if (_events.containsKey(key)) {
                            _events[key]!.add(_eventController.text);
                          } else {
                            _events[key] = [_eventController.text];
                          }
                        });
                        current = current.add(const Duration(days: 1));
                      }

                      _eventController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Etkinliği Oluştur',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String month = DateFormat.MMMM('tr_TR').format(_focusedDay);
    final List<DateTime> weekDays = List.generate(
        7,
        (i) =>
            _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1 - i)));

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Etkinlik ve Takvim Sayfam",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: _openDatePicker,
            icon:
                const Icon(Icons.calendar_today_outlined, color: Colors.white),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              month[0].toUpperCase() + month.substring(1),
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              DateFormat('dd MMMM yyyy', 'tr_TR').format(DateTime.now()),
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                final day = weekDays[index];
                final isSelected = isSameDay(day, _selectedDay);
                return Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = day;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.yellowAccent
                            : const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.E('tr_TR').format(day),
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            day.day.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  "Etkinlikler",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showCalendarModal,
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _events.entries
                  .where((entry) =>
                      isSameDay(entry.key, _selectedDay ?? _focusedDay))
                  .expand((entry) {
                return entry.value.map((event) {
                  final now = DateTime.now();
                  final todayDate = DateTime(now.year, now.month, now.day);
                  final eventDate =
                      DateTime(entry.key.year, entry.key.month, entry.key.day);
                  final int daysLeft = eventDate.difference(todayDate).inDays;
                  final bool isUpcoming = daysLeft >= 0 && daysLeft <= 3;

                  return Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(16),
                      border: isUpcoming
                          ? Border.all(color: Colors.amber, width: 2)
                          : Border.all(color: Colors.grey.shade800),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
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
                              const Icon(Icons.access_time,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                daysLeft == 0
                                    ? "Etkinlik bugün"
                                    : "Etkinliğe $daysLeft gün kaldı",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.event_note,
                                color: Colors.white70, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                event,
                                style: const TextStyle(
                                  color: Colors.white,
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
                            const Icon(Icons.calendar_today,
                                color: Colors.white54, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('d MMMM y', 'tr_TR').format(eventDate),
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
