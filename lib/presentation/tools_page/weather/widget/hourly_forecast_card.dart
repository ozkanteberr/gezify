import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gezify/presentation/tools_page/weather/widget/weather.dart';

class HourlyForecastCard extends StatelessWidget {
  final HourlyForecast hour;

  const HourlyForecastCard({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(0, 125, 125, 125),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.Hm().format(hour.time),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Image.network(
            'https://openweathermap.org/img/wn/${hour.iconCode.replaceAll('n', 'd')}@2x.png',
            width: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.cloud, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            '${hour.temp.round()}°',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
