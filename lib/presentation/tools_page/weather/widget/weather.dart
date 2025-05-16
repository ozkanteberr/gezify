class Weather {
  final String cityName;
  final double currentTemp;
  final String currentIcon;
  final String description;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  Weather({
    required this.cityName,
    required this.currentTemp,
    required this.currentIcon,
    required this.description,
    required this.hourly,
    required this.daily,
  });

  factory Weather.fromForecastJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>;

    final hourly = list.take(6).map((e) {
      final dt = DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000);
      final temp = (e['main']['temp'] as num).toDouble();
      final icon = e['weather'][0]['icon'];
      return HourlyForecast(time: dt, temp: temp, iconCode: icon);
    }).toList();

    final groupedByDate = <String, List<dynamic>>{};
    for (var e in list) {
      final date = DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000).toIso8601String().split('T')[0];
      groupedByDate.putIfAbsent(date, () => []).add(e);
    }

    final daily = groupedByDate.entries.take(7).map((entry) {
      final dayData = entry.value;
      final date = DateTime.fromMillisecondsSinceEpoch(dayData[0]['dt'] * 1000);
      double min = double.infinity, max = double.negativeInfinity;
      String icon = dayData[0]['weather'][0]['icon'];
      for (var d in dayData) {
        final t = (d['main']['temp'] as num).toDouble();
        if (t < min) min = t;
        if (t > max) max = t;
      }
      return DailyForecast(date: date, tempMin: min, tempMax: max, iconCode: icon);
    }).toList();

    final current = list[0];
    return Weather(
      cityName: json['city']['name'],
      currentTemp: (current['main']['temp'] as num).toDouble(),
      currentIcon: current['weather'][0]['icon'],
      description: current['weather'][0]['description'],
      hourly: hourly,
      daily: daily,
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double temp;
  final String iconCode;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.iconCode,
  });
}

class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String iconCode;

  DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.iconCode,
  });
}