import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart';
import 'package:gezify/presentation/maps/bloc/map_screen_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GoogleMapScreen extends StatefulWidget {
  final Destination destination;

  const GoogleMapScreen({Key? key, required this.destination})
      : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition =
      const LatLng(41.015137, 28.979530); // Default İstanbul
  bool _locationLoaded = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();

    // Info kutusunu sayfa açılınca göster
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pos =
          LatLng(widget.destination.latitude, widget.destination.longitude);
      context.read<GoogleMapCubit>().showInfo(pos);
    });
  }

  Future<void> _determinePosition() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _locationLoaded = true;
      });
    } else {
      setState(() => _locationLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;

    return Scaffold(
      appBar: AppBar(title: const Text("Google Harita")),
      body: _locationLoaded
          ? Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(destination.latitude, destination.longitude),
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: {
                    Marker(
                      icon: AssetMapBitmap("assets/images/marker.png",
                          width: 50, height: 50),
                      markerId: MarkerId(destination.title),
                      position:
                          LatLng(destination.latitude, destination.longitude),
                      onTap: () {
                        context.read<GoogleMapCubit>().showInfo(
                              LatLng(
                                  destination.latitude, destination.longitude),
                            );
                      },
                    )
                  },
                ),

                // Info kutusu
                BlocBuilder<GoogleMapCubit, LatLng?>(
                  builder: (context, selectedPosition) {
                    if (selectedPosition == null) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      bottom: 80,
                      left: 16,
                      right: 16,
                      child: SafeArea(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 350),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      height: 160,
                                      viewportFraction: 0.9,
                                      enableInfiniteScroll: false,
                                      enlargeCenterPage: true,
                                    ),
                                    items: destination.images.map((imageUrl) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              const Center(
                                                  child:
                                                      Icon(Icons.broken_image)),
                                          loadingBuilder:
                                              (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    destination.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    destination.adress,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: -8,
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<GoogleMapCubit>().hideInfo();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
