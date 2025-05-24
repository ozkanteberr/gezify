import 'package:equatable/equatable.dart';

class PublicRouteState extends Equatable {
  const PublicRouteState();

  @override
  List<Object?> get props => [];
}

class PublicRouteLoading extends PublicRouteState {}

class PublicRouteLoaded extends PublicRouteState {
  final List<Map<String, dynamic>> publicRoutes;

  const PublicRouteLoaded(this.publicRoutes);

  @override
  List<Object?> get props => [publicRoutes];
}

class PublicRouteError extends PublicRouteState {
  final String message;

  const PublicRouteError(this.message);

  @override
  List<Object?> get props => [message];
}
