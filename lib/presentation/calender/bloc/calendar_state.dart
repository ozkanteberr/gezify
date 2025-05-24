import 'package:equatable/equatable.dart';
import 'package:gezify/presentation/calender/models/calendar_event_model.dart';


class CalendarState extends Equatable {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<CalendarEventModel>> events;

  const CalendarState({
    required this.focusedDay,
    this.selectedDay,
    required this.events,
  });

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    Map<DateTime, List<CalendarEventModel>>? events,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      events: events ?? this.events,
    );
  }

  @override
  List<Object?> get props => [focusedDay, selectedDay, events];
}
