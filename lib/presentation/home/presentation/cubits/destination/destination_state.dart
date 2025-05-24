part of 'destination_cubit.dart';

abstract class DestinationState {}

class DestinationInitial extends DestinationState {}

class DestinationLoading extends DestinationState {}

class DestinationLoaded extends DestinationState {
  final List<Destination> allDestinations;
  final List<Destination> filteredDestinations;

  DestinationLoaded(this.allDestinations, {List<Destination>? filtered})
      : filteredDestinations = filtered ?? allDestinations;
}

class DestinationSelected extends DestinationState {
  final Destination destination;

  DestinationSelected(this.destination);
}

class DestinationError extends DestinationState {
  final String message;

  DestinationError(this.message);
}
