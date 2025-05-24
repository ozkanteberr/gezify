import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class AddEvent extends CalendarEvent {
  final String title;
  final DateTime start;
  final DateTime end;

  const AddEvent({required this.title, required this.start, required this.end});

  @override
  List<Object> get props => [title, start, end];
}

class SelectDay extends CalendarEvent {
  final DateTime day;

  const SelectDay(this.day);

  @override
  List<Object> get props => [day];
}

class ChangeFocus extends CalendarEvent {
  final DateTime focusedDay;

  const ChangeFocus(this.focusedDay);

  @override
  List<Object> get props => [focusedDay];
}
