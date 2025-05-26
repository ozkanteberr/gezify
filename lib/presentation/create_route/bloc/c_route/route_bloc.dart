import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'route_event.dart';
import 'route_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(RouteState([])) {
    on<AddDestinationToRoute>((event, emit) {
      final newRoutes = List<Destination>.from(state.routes)
        ..add(event.destination);
      emit(state.copyWith(routes: newRoutes));
    });

    on<RemoveDestinationFromRoute>((event, emit) {
      final newRoutes = List<Destination>.from(state.routes)
        ..removeAt(event.index);
      emit(state.copyWith(routes: newRoutes));
    });

    on<TogglePrivacy>((event, emit) {
      emit(state.copyWith(isPrivate: event.isPrivate));
    });

    on<ClearDestinations>((event, emit) {
      emit(RouteState([], isPrivate: state.isPrivate));
    });

    on<SaveDestinationsToFirebase>((event, emit) async {
      try {
        final firestore = FirebaseFirestore.instance;
        final routeDoc = firestore.collection('userRoutes').doc(event.uid);
        final routeLists = routeDoc.collection('routeLists');

        final destinationsMap = state.routes
            .map((destination) => {
                  'title': destination.title,
                  'latitude': destination.latitude,
                  'longitude': destination.longitude,
                })
            .toList();

        final String routeId = const Uuid().v4(); // Random ID oluşturur.

        final routeData = {
          'routeId': routeId,
          'title': event.listTitle,
          'isPrivate': state.isPrivate,
          'createdAt': FieldValue.serverTimestamp(),
          'routes': destinationsMap,
        };

        final publicData = {
          'routeId': routeId,
          'title': event.listTitle,
          'routes': destinationsMap,
        };

        await routeLists.doc(routeId).set(routeData);

        if (!state.isPrivate) {
          await firestore
              .collection('publicUserRoutes')
              .doc(routeId)
              .set(publicData);
        }
      } catch (e) {
        print("Firebase'e kaydetme hatası: $e");
      }
    });

    on<LoadRouteWithCurrentLocation>((event, emit) async {
      List<LatLng> polylineCoords = [];
      String? totalDistance;
      String? totalDuration;

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Map<String, dynamic>> fullPoints = [
          {'latitude': position.latitude, 'longitude': position.longitude},
          ...event.routePoints,
        ];

        final apiKey = 'AIzaSyCzQ2JlCB0z20541yrwz_l7T6um9NhD4gw';

        for (int i = 0; i < fullPoints.length - 1; i++) {
          final origin = fullPoints[i];
          final destination = fullPoints[i + 1];

          final url =
              'https://maps.googleapis.com/maps/api/directions/json?origin=${origin['latitude']},${origin['longitude']}&destination=${destination['latitude']},${destination['longitude']}&key=$apiKey&mode=driving';

          final response = await http.get(Uri.parse(url));
          final data = jsonDecode(response.body);

          if (data['routes'].isNotEmpty) {
            final points = data['routes'][0]['overview_polyline']['points'];
            final decodedPoints = PolylinePoints().decodePolyline(points);
            polylineCoords.addAll(
                decodedPoints.map((p) => LatLng(p.latitude, p.longitude)));

            if (i == 0) {
              totalDistance = data['routes'][0]['legs'][0]['distance']['text'];
              totalDuration = data['routes'][0]['legs'][0]['duration']['text'];
            }
          }
        }

        emit(state.copyWith(
          polylineCoordinates: polylineCoords,
          totalDistance: totalDistance,
          totalDuration: totalDuration,
        ));
      } catch (e) {
        print("Hata oluştu: $e");
      }
    });
  }
}
