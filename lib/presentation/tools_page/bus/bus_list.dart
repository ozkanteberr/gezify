import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/tools_page/bus/bloc/bus_bloc.dart';

class BusListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Otbüs Seferleri Listesi")),
      body: BlocBuilder<BusBloc, BusState>(
        builder: (context, state) {
          if (state is BusLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BusLoaded) {
            return ListView.builder(
              itemCount: state.bus.length,
              itemBuilder: (context, index) {
                final bus = state.bus[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: ListTile(
                    title: Text("${bus.busCompany} - ₺${bus.price}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🚎 ${bus.departure} - ${bus.departureTime}"),
                        Text("🚍 ${bus.arrival} - ${bus.arrivalTime}"),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is BusError) {
            return Center(child: Text("Hata: ${state.message}"));
          }
          return Container();
        },
      ),
    );
  }
}
