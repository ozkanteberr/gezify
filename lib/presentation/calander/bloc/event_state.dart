import 'package:gezify/presentation/calander/model/event_model.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<EventModel> events;
  EventLoaded(this.events);
}

class EventError extends EventState {
  final String message;
  EventError(this.message);
}
