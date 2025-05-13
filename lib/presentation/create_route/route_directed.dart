import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gezify/presentation/create_route/route_page.dart';

class RouteDirected extends StatelessWidget {
  const RouteDirected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Rota Yönetimi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _glassButton(
                context,
                icon: Icons.add_location_alt_outlined,
                title: "Rota Oluştur",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RoutePage()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _glassButton(
                context,
                icon: Icons.favorite_border,
                title: "Favori Rotaları Gör",
                onTap: () => print("Favori Rotalar"),
              ),
              const SizedBox(height: 25),
              _glassButton(
                context,
                icon: Icons.list_alt_outlined,
                title: "Kaydedilen Rotalar",
                onTap: () => print("İste Rotalarım"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassButton(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
