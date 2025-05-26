import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/tools_page/bus/data/bus_repo.dart';
import 'package:gezify/presentation/tools_page/bus/model/bus.dart';

abstract class BusEvent {}

class LoadBus extends BusEvent {}

abstract class BusState {}

class BusInitial extends BusState {}

class BusLoading extends BusState {}

class BusLoaded extends BusState {
  final List<Bus> bus;
  BusLoaded(this.bus);
}

class BusError extends BusState {
  final String message;
  BusError(this.message);
}

class BusBloc extends Bloc<BusEvent, BusState> {
  final BusRepository repository;
  BusBloc(this.repository) : super(BusInitial()) {
    on<LoadBus>((event, emit) async {
      emit(BusLoading());
      try {
        final bus = await repository.fetchBus();
        emit(BusLoaded(bus));
      } catch (e) {
        emit(BusError(e.toString()));
      }
    });
  }
}
