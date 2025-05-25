import 'package:gezify/presentation/calander/model/event_model.dart';

abstract class EventEvent {}

class LoadEvents extends EventEvent {
  final DateTime selectedDate;
  LoadEvents(this.selectedDate);
}

class AddEvent extends EventEvent {
  final EventModel event;
  AddEvent(this.event);
}

class EventsLoaded extends EventEvent {
  final List<EventModel> events;
  EventsLoaded(this.events);
}
