import 'package:gezify/presentation/destination/model/destination_model.dart';

abstract class DestinationDetailState {}

class DestinationLoading extends DestinationDetailState {}

class DestinationLoaded extends DestinationDetailState {
  final DestinationInfo destination;

  DestinationLoaded(this.destination);
}

class DestinationError extends DestinationDetailState {
  final String message;

  DestinationError(this.message);
}
