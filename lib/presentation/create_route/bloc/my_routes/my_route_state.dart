import 'package:gezify/presentation/create_route/data/route_model.dart';

abstract class MyRoutesState {}

class MyRoutesInitial extends MyRoutesState {}

class MyRoutesLoading extends MyRoutesState {}

class MyRoutesLoaded extends MyRoutesState {
  final List<RouteList> routeLists;
  MyRoutesLoaded(this.routeLists);
}

class MyRoutesError extends MyRoutesState {
  final String message;
  MyRoutesError(this.message);
}
