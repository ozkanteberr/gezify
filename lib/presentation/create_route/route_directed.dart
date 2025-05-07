import 'package:flutter/material.dart';
import 'package:gezify/presentation/create_route/route_page.dart';

class RouteDirected extends StatelessWidget {
  const RouteDirected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rota Yönetimi", 
              style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureButton(
              context: context,
              icon: Icons.add_location_alt,
              title: "Rota Oluştur",
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RoutePage()),
            ),
            ),
            const SizedBox(height: 25),
            _buildFeatureButton(
              context: context,
              icon: Icons.favorite,
              title: "Favori Rotaları Gör",
              color: Colors.pink,
              onTap: () => print("Favori Rotalar"),
            ),
            const SizedBox(height: 25),
            _buildFeatureButton(
              context: context,
              icon: Icons.list_alt,
              title: "İste Rotalarımı Gör",
              color: Colors.purple,
              onTap: () => print("İste Rotalarım"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: color.withOpacity(0.2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}