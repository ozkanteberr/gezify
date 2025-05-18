import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gezify/presentation/tools_page/weather/widget/weather.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecast day;

  const DailyForecastCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(0, 125, 125, 125),
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.E('tr_TR').format(day.date),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Image.network(
            'https://openweathermap.org/img/wn/${day.iconCode.replaceAll('n', 'd')}@2x.png',
            width: 40,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_upward, size: 14, color: Colors.redAccent),
              Text(
                '${day.tempMax.round()}°',
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_downward, size: 14, color: Colors.lightBlueAccent),
              Text(
                '${day.tempMin.round()}°',
                style: const TextStyle(color: Colors.lightBlueAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
