import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/home/data/destination_repository.dart';
import '../../../domain/entities/destination.dart';

part 'destination_state.dart';

class DestinationCubit extends Cubit<DestinationState> {
  final DestinationRepository repository;

  DestinationCubit({required this.repository}) : super(DestinationInitial());

  Future<void> loadBestDestinations() async {
    emit(DestinationLoading());
    try {
      final destinations = await repository.fetchBestDestinations();
      emit(DestinationLoaded(destinations));
    } catch (e) {
      emit(DestinationError('Veriler alınamadı: $e'));
    }
  }

  Future<void> fetchDestinationsByCategory(String category) async {
    emit(DestinationLoading());

    try {
      final destinations = await repository.getDestinationsByCategory(category);
      emit(DestinationLoaded(destinations));
    } catch (e) {
      emit(DestinationError('Veri alınamadı: $e'));
    }
  }

  void filterDestinations(String query) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      final filtered = currentState.allDestinations.where((destination) {
        return destination.title.toLowerCase().contains(query.toLowerCase()) ||
            destination.adress.toLowerCase().contains(query.toLowerCase());
      }).toList();

      emit(DestinationLoaded(
        currentState.allDestinations,
        filtered: filtered,
      ));
    }
  }

  void selectDestination(Destination destination) {
    emit(DestinationSelected(destination));
  }
}
