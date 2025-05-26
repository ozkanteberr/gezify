import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/tools_page/flight/data/flight_repository.dart';
import 'package:gezify/presentation/tools_page/flight/model/flight.dart';

abstract class FlightEvent {}

class LoadFlights extends FlightEvent {}

abstract class FlightState {}

class FlightInitial extends FlightState {}

class FlightLoading extends FlightState {}

class FlightLoaded extends FlightState {
  final List<Flight> flights;
  FlightLoaded(this.flights);
}

class FlightError extends FlightState {
  final String message;
  FlightError(this.message);
}

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final FlightRepository repository;
  FlightBloc(this.repository) : super(FlightInitial()) {
    on<LoadFlights>((event, emit) async {
      emit(FlightLoading());
      try {
        final flights = await repository.fetchFlights();
        emit(FlightLoaded(flights));
      } catch (e) {
        emit(FlightError(e.toString()));
      }
    });
  }
}
