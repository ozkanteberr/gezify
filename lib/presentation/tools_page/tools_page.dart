// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/tools_page/ai/ai_page.dart';
import 'package:gezify/presentation/tools_page/currency/bloc/currency_bloc.dart';
import 'package:gezify/presentation/tools_page/currency/bloc/currency_event.dart';
import 'package:gezify/presentation/tools_page/currency/bloc/currency_state.dart';
import 'package:gezify/presentation/tools_page/weather/widget/weather_details_page.dart';

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
           centerTitle: true,
        title: const Text('Araçlar'),
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: const Color(0xFFE8F5F2),
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFE8F5F2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (hasBusTicket)
              _buildToolCard(context, "Otobüs Bileti", CupertinoIcons.bus,
                  const Color(0xFF3D7B82)),
            if (hasPlaneTicket)
              _buildToolCard(context, "Uçak Bileti", CupertinoIcons.airplane,
                  const Color(0xFF2E5C66)),
            _buildAiCard(context),
            _buildWeatherCard(context),
            _buildRequestCard(context),
            _buildCurrencyCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
      BuildContext context, String title, IconData icon, Color iconColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFFFFFFF),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF2F3E46),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Color(0xFF004D40)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$title seçildi',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF004D40),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFFFFFFF),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFFF3E0),
          child: Icon(CupertinoIcons.cloud_sun, color: Colors.orange),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Color(0xFF004D40)),
        title: const Text(
          "Hava Durumu",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF2F3E46),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(
                content: Text(
                  'Hava durumu detaylarına gidiliyor...',
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFF004D40),
              ))
              .closed
              .then((_) async {
            await Future.delayed(
                const Duration(milliseconds: 1)); // 1 saniye bekle
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              color: const Color(0xFFFFFFFF),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(CupertinoIcons.money_dollar,
                      color: Color(0xFF00796B)),
                ),
                title: const Text(
                  "Döviz Kurları",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF2F3E46),
                  ),
                ),
                subtitle: Text(
                  "USD/TRY: $usd  |  EUR/TRY: $eur",
                  style: const TextStyle(
                    color: Color(0xFF2F3E46),
                    fontSize: 13,
                  ),
                ),
                trailing:
                    const Icon(Icons.sync_outlined, color: Color(0xFF004D40)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Döviz kuru güncelleniyor...',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xFF004D40),
                      duration: Duration(seconds: 2),
                    ),
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

  Widget _buildAiCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFFFFFFF),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 247, 209, 255),
          child: Icon(Icons.psychology_outlined,
              color: Color.fromARGB(255, 47, 64, 70)),
        ),
        title: const Text(
          "Yapay Zekaya Sor",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF2F3E46)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Color(0xFF004D40)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AiPage()),
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFFFFFFF),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.feedback_outlined, color: Color(0xFF1565C0)),
        ),
        title: const Text(
          "İstek & Talep Kutusu",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF2F3E46),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Color(0xFF004D40)),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController _controller = TextEditingController();
              return AlertDialog(
                backgroundColor: Color(0xFFE8F5F2),
                title: const Text("Geri Bildirim"),
                content: TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Lütfen istek veya talebinizi yazınız...",
                    border: OutlineInputBorder(),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'İptal',
                      style: TextStyle(color: Color(0xFF00796B)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40)),
                    child: const Text(
                      'Gönder',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // Burada geri bildirim işleme kodu olabilir.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Geri bildiriminiz için teşekkür ederiz."),
                          backgroundColor: Color(0xFF004D40),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
