// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/tools_page/bloc/currency_bloc.dart';
import 'package:gezify/presentation/tools_page/bloc/currency_event.dart';
import 'package:gezify/presentation/tools_page/bloc/currency_state.dart';
import 'package:gezify/presentation/tools_page/weather/bloc/weather_details_page.dart';



class ToolsPage extends StatelessWidget {
  final bool hasBusTicket;
  final bool hasPlaneTicket;

  const ToolsPage({
    Key? key,
    this.hasBusTicket = true,
    this.hasPlaneTicket = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araçlar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (hasBusTicket)
              _buildToolCard(context, "Otobüs Bileti", CupertinoIcons.bus),
            if (hasPlaneTicket)
              _buildToolCard(context, "Uçak Bileti", CupertinoIcons.airplane),
            _buildWeatherCard(context),
            _buildCurrencyCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title seçildi')),
          );
        },
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(CupertinoIcons.cloud_sun, color: Colors.orange),
        title: const Text("Hava Durumu"),
        subtitle: const Text("İstanbul: 22°C, Güneşli"),
        onTap: () {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Hava durumu detaylarına gidiliyor...'),
      duration: Duration(seconds: 1), // 1 saniye göster
    ),
  ).closed.then((_) { // SnackBar kapandıktan sonra
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeatherDetailsPage()),
    );
  });
},
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrencyBloc()..add(FetchCurrencyRates()),
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, state) {
          if (state is CurrencyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CurrencyError) {
            return Center(child: Text(state.message));
          } else if (state is CurrencyLoaded) {
            final usd = state.rates['USD']?.toStringAsFixed(2) ?? 'N/A';
            final eur = state.rates['EUR']?.toStringAsFixed(2) ?? 'N/A';

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(CupertinoIcons.money_dollar, color: Colors.green),
                title: const Text("Döviz Kurları"),
                subtitle: Text("USD/TRY: $usd  |  EUR/TRY: $eur"),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Döviz kuru detayları yükleniyor...')),
                  );
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

 
}

