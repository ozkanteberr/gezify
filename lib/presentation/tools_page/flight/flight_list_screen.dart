import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/tools_page/flight/bloc/flight_bloc.dart';

class FlightListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Uçuş Listesi")),
      body: BlocBuilder<FlightBloc, FlightState>(
        builder: (context, state) {
          if (state is FlightLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FlightLoaded) {
            return ListView.builder(
              itemCount: state.flights.length,
              itemBuilder: (context, index) {
                final flight = state.flights[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: ListTile(
                    title: Text("${flight.airline} - ₺${flight.price}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "🛫 ${flight.departure} - ${flight.departureTime}"),
                        Text("🛬 ${flight.arrival} - ${flight.arrivalTime}"),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is FlightError) {
            return Center(child: Text("Hata: ${state.message}"));
          }
          return Container();
        },
      ),
    );
  }
}
