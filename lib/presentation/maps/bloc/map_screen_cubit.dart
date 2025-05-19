import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapCubit extends Cubit<LatLng?> {
  GoogleMapCubit() : super(null);

  void showInfo(LatLng position) {
    emit(position);
  }

  void hideInfo() {
    emit(null);
  }
}
