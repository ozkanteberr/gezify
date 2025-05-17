import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gezify/presentation/tools_page/weather/widget/weather.dart';
import 'package:gezify/presentation/tools_page/weather/service/weather_service.dart';
import 'package:intl/intl.dart';



class WeatherDetailsPage extends StatefulWidget {
  const WeatherDetailsPage({super.key});

  @override
  State<WeatherDetailsPage> createState() => _HomePageState();
}

class _HomePageState extends State<WeatherDetailsPage> {
  final weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  Weather? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getLocationAndWeather() async {
    setState(() => isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Konum servisleri devre dışı.');

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw Exception('Konum izni verilmedi.');

      Position position = await Geolocator.getCurrentPosition();
      weatherData = await weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print("Hata: $e");
    }
    setState(() => isLoading = false);
  }

  Future<void> fetchByCity() async {
    final city = _controller.text;
    if (city.isEmpty) return;
    setState(() => isLoading = true);
    try {
      weatherData = await weatherService.getWeatherByCity(city);
    } catch (e) {
      print("Şehir bulunamadı: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 132, 141, 236),
                const Color(0xFF303F9F),
              ],
            ),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      );
    }
    if (weatherData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white54, size: 48),
            const SizedBox(height: 16),
            Text(
              "Veri alınamadı",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 30),
          _buildCurrentWeather(),
          const SizedBox(height: 40),
          _buildHourlyForecast(),
          const SizedBox(height: 30),
          _buildWeeklyForecast(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Şehir ara...",
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white54),
            onPressed: fetchByCity,
            
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Column(
      children: [
        Text(
          weatherData!.cityName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Image.network(
          'https://openweathermap.org/img/wn/${weatherData!.currentIcon}@4x.png',
          height: 120,
        ),
        Text(
          '${weatherData!.currentTemp}°C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 56,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          weatherData!.description.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Saatlik Tahmin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weatherData!.hourly.length,
            itemBuilder: (context, index) {
              final hour = weatherData!.hourly[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.Hm().format(hour.time),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.network(
                        'https://openweathermap.org/img/wn/${hour.iconCode}@2x.png',
                        height: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${hour.temp}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "7 Günlük Tahmin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weatherData!.daily.map((day) {
                return Column(
                  children: [
                    Text(
                      DateFormat.E('tr').format(day.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Image.network(
                      'https://openweathermap.org/img/wn/${day.iconCode}@2x.png',
                      height: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${day.tempMax}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${day.tempMin}°',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}