import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/calander/data/event_repo.dart';
import 'package:gezify/presentation/calander/model/event_model.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  StreamSubscription<List<EventModel>>? _eventsSubscription;

  EventBloc(this.eventRepository) : super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddEvent>(_onAddEvent);
    on<EventsLoaded>(_onEventsLoaded);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());

    await _eventsSubscription?.cancel();

    try {
      _eventsSubscription = eventRepository.getEvents().listen((events) {
        final filtered = events
            .where((e) =>
                e.date.year == event.selectedDate.year &&
                e.date.month == event.selectedDate.month &&
                e.date.day == event.selectedDate.day)
            .toList();

        add(EventsLoaded(filtered));
      });
    } catch (e) {
      emit(EventError('Etkinlikler yüklenirken hata oluştu: $e'));
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EventState> emit) async {
    try {
      await eventRepository.addEvent(event.event);
    } catch (e) {
      emit(EventError('Etkinlik eklenirken hata oluştu: $e'));
    }
  }

  void _onEventsLoaded(EventsLoaded event, Emitter<EventState> emit) {
    emit(EventLoaded(event.events));
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }
}
