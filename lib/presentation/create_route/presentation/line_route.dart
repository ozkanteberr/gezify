import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LineRoutePage extends StatefulWidget {
  final List<dynamic> routeData;

  const LineRoutePage({super.key, required this.routeData});

  @override
  State<LineRoutePage> createState() => _LineRoutePageState();
}

class _LineRoutePageState extends State<LineRoutePage> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _carIcon;
  Timer? _carMoveTimer;
  int _carIndex = 0;

  @override
  void initState() {
    super.initState();

    final filtered = widget.routeData
        .where((e) => e is Map<String, dynamic>)
        .cast<Map<String, dynamic>>()
        .toList();

    context.read<RouteBloc>().add(LoadRouteWithCurrentLocation(filtered));
    _loadCarIcon();
  }

  void _loadCarIcon() async {
    _carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 6.5),
      'assets/images/car_icon.png',
    );
  }

  @override
  void dispose() {
    _carMoveTimer?.cancel();
    super.dispose();
  }

  void _animateCar(List<LatLng> polylineCoordinates) {
    _carMoveTimer?.cancel();
    _carIndex = 0;

    _carMoveTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_carIndex >= polylineCoordinates.length) {
        timer.cancel();
        return;
      }

      setState(() {
        _carIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Haritada Rota")),
      body: BlocBuilder<RouteBloc, RouteState>(
        builder: (context, state) {
          if (state.polylineCoordinates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Yalnızca veritabanından gelen yerler için marker'lar
          final routeMarkers = widget.routeData
              .where((e) => e is Map<String, dynamic>)
              .cast<Map<String, dynamic>>()
              .map((point) {
            return Marker(
              markerId: MarkerId("${point['latitude']}_${point['longitude']}"),
              position: LatLng(point['latitude'], point['longitude']),
              infoWindow: const InfoWindow(title: "Rota Noktası"),
            );
          }).toSet();

          // Araç marker'ı
          if (_carIcon != null &&
              _carIndex < state.polylineCoordinates.length) {
            routeMarkers.add(
              Marker(
                markerId: const MarkerId("car"),
                icon: _carIcon!,
                position: state.polylineCoordinates[_carIndex],
                anchor: const Offset(0.5, 0.5),
              ),
            );
          }

          final polyline = Polyline(
            polylineId: const PolylineId("route_line"),
            color: Colors.blue,
            width: 4,
            points: state.polylineCoordinates,
          );

          // Harita çizimi bittikten sonra animasyonu başlat
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _animateCar(state.polylineCoordinates);
          });

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: state.polylineCoordinates.first,
                  zoom: 14,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: routeMarkers,
                polylines: {polyline},
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              if (state.totalDistance != null && state.totalDuration != null)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    color: Colors.white,
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Mesafe: ${state.totalDistance} | Süre: ${state.totalDuration}",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
