import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/destination/bloc/destination_event.dart';
import 'package:gezify/presentation/destination/bloc/destination_state.dart';
import 'package:gezify/presentation/destination/model/destination_model.dart';

class DestinationDetailBloc
    extends Bloc<DestinationDetailEvent, DestinationDetailState> {
  DestinationDetailBloc() : super(DestinationLoading()) {
    on<LoadDestinationDetail>((event, emit) async {
      try {
        await Future.delayed(const Duration(seconds: 1)); // Simülasyon
        final destination = DestinationInfo(
          name: "Uzungöl",
          adress: 'Çaykara, Trabzon',
          imageUrl:
              "https://seralakehotel.com/trabzonda-gezilecek-yerler/uzungol/",
          detailImage: [
            "https://seralakehotel.com/trabzonda-gezilecek-yerler/uzungol/",
            "https://www.google.com/imgres?q=uzung%C3%B6l&imgurl=https%3A%2F%2Fseralakehotel.com%2Fwp-content%2Fuploads%2F2025%2F04%2FTrabzon-Uzungol-Gezi-Rehberi-8.webp&imgrefurl=https%3A%2F%2Fseralakehotel.com%2Ftrabzonda-gezilecek-yerler%2Fuzungol%2F&docid=6Mx2yZxN3pvd0M&tbnid=Rc-aV-xp8UrDuM&vet=12ahUKEwjsxey68KqNAxUySvEDHTikKQcQM3oECGkQAA..i&w=1600&h=1069&hcb=2&ved=2ahUKEwjsxey68KqNAxUySvEDHTikKQcQM3oECGkQAA",
            "https://seralakehotel.com/trabzonda-gezilecek-yerler/uzungol/",
          ],
          description: 'Trabzon Uzungöl detay',
          latitude: 40.619494,
          longitude: 40.235097,
          rating: 4.7,
        );

        emit(DestinationLoaded(destination));
      } catch (e) {
        emit(DestinationError("Veri yüklenemedi"));
      }
    });
  }
}
