import 'package:flutter/material.dart';
import 'package:gezify/presentation/tools_page/weather/widget/weather.dart';
import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        Text(
          '${weather.currentTemp.round()}°C',
          style: const TextStyle(fontSize: 48, color: Colors.white),
        ),
        Text(
          weather.description,
          style: const TextStyle(fontSize: 18, color: Colors.white70),
        ),
        const SizedBox(height: 24),
        const Text('Saatlik Tahmin', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weather.hourly.length,
            itemBuilder: (context, index) {
              final hour = weather.hourly[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(DateFormat.Hm().format(hour.time), style: const TextStyle(color: Colors.white)),
                    Image.network(
                      'https://openweathermap.org/img/wn/${hour.iconCode.replaceAll('n', 'd')}@2x.png',
                      width: 40,
                    ),
                    Text('${hour.temp.round()}°', style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text('7 Günlük Tahmin', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weather.daily.length,
            itemBuilder: (context, index) {
              final day = weather.daily[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      DateFormat.E().format(day.date),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Image.network(
                      'https://openweathermap.org/img/wn/${day.iconCode.replaceAll('n', 'd')}@2x.png',
                      width: 40,
                    ),
                    Text('${day.tempMax.round()}° / ${day.tempMin.round()}°',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
