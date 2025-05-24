import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PublicRouteEvent extends Equatable {
  const PublicRouteEvent();

  @override
  List<Object?> get props => [];
}

class LoadPublicRoutes extends PublicRouteEvent {}

class PublicRouteUpdated extends PublicRouteEvent {
  final List<QueryDocumentSnapshot> docs;

  const PublicRouteUpdated(this.docs);

  @override
  List<Object?> get props => [docs];
}
