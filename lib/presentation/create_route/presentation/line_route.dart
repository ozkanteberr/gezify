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

  @override
  void initState() {
    super.initState();

    // Sadece Map veri tiplerini filtrele
    final filtered = widget.routeData
        .where((e) => e is Map<String, dynamic>)
        .cast<Map<String, dynamic>>()
        .toList();

    context.read<RouteBloc>().add(LoadRouteOnMap(filtered));
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

          final markers = state.polylineCoordinates
              .map((coord) => Marker(
                    markerId: MarkerId(coord.toString()),
                    position: coord,
                  ))
              .toSet();

          final polyline = Polyline(
            polylineId: const PolylineId("route_line"),
            color: Colors.blue,
            width: 4,
            points: state.polylineCoordinates,
          );

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.polylineCoordinates.first,
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: markers,
            polylines: {polyline},
          );
        },
      ),
    );
  }
}
