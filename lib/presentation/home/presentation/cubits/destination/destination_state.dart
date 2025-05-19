part of 'destination_cubit.dart';

abstract class DestinationState {}

class DestinationInitial extends DestinationState {}

class DestinationLoading extends DestinationState {}

class DestinationLoaded extends DestinationState {
  final List<Destination> destinations;

  DestinationLoaded(this.destinations);
}

class DestinationSelected extends DestinationState {
  final Destination destination;

  DestinationSelected(this.destination);
}

class DestinationError extends DestinationState {
  final String message;

  DestinationError(this.message);
}
