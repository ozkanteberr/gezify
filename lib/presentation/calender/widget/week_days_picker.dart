import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekDaysPicker extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;

  const WeekDaysPicker({
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final weekDays = List.generate(7, (i) =>
        focusedDay.subtract(Duration(days: focusedDay.weekday - 1 - i)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        itemBuilder: (context, index) => _buildDayItem(context, weekDays[index]),
      ),
    );
  }

  Widget _buildDayItem(BuildContext context, DateTime day) {
    final isSelected = isSameDay(day, selectedDay);
    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => onDaySelected(day),
        borderRadius: BorderRadius.circular(12),
        splashColor: const Color(0xFF007965).withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF007965) : const Color(0xFFF1F9F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF007965) : const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat.E('tr_TR').format(day),
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF007965),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                day.day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF004D40),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
