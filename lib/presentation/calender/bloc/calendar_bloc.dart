import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/calender/pages/calendar_event_model.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
      : super(CalendarState(
          focusedDay: DateTime.now(),
          selectedDay: DateTime.now(),
          events: {},
        )) {
    on<AddEvent>(_onAddEvent);
    on<SelectDay>(_onSelectDay);
    on<ChangeFocus>(_onChangeFocus);
  }

  void _onAddEvent(AddEvent event, Emitter<CalendarState> emit) {
    final updatedEvents = Map<DateTime, List<CalendarEventModel>>.from(state.events);
    DateTime current = event.start;

    while (!current.isAfter(event.end)) {
      final key = DateTime.utc(current.year, current.month, current.day);
      final list = updatedEvents[key] ?? [];
      list.add(CalendarEventModel(title: event.title, date: key));
      updatedEvents[key] = list;
      current = current.add(const Duration(days: 1));
    }

    emit(state.copyWith(events: updatedEvents));
  }

  void _onSelectDay(SelectDay event, Emitter<CalendarState> emit) {
    emit(state.copyWith(selectedDay: event.day));
  }

  void _onChangeFocus(ChangeFocus event, Emitter<CalendarState> emit) {
    emit(state.copyWith(focusedDay: event.focusedDay));
  }
}
