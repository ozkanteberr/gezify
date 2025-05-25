import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gezify/presentation/create_route/presentation/my_routes.dart';
import 'package:gezify/presentation/create_route/presentation/public_route_page/public_route_page.dart';
import 'package:gezify/presentation/create_route/presentation/route/route_page.dart';
import 'package:gezify/presentation/create_route/presentation/save_route_page/save_route_page.dart';

class RouteDirected extends StatelessWidget {
  const RouteDirected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Rota Yönetimi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0C3B2E),
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/rota.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 390),
                _glassButton(
                  context,
                  icon: Icons.add_location_alt_outlined,
                  title: "Rota Oluştur",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RouteView()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _glassButton(
                  context,
                  icon: Icons.public,
                  title: "Herkese Açık Rotalar",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PublicRouteListPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _glassButton(
                  context,
                  icon: Icons.bookmark,
                  title: "Kaydedilen Rotalar",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SaveRouteListPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _glassButton(
                  context,
                  icon: Icons.list_alt,
                  title: "Benim Rotalarım",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyRoutesPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xCCF1F8F6).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.fromRGBO(0, 77, 64, 1), // Siyah kenarlık
                width: 1.8, // Kenarlık kalınlığı
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Color.fromRGBO(0, 77, 64, 1), size: 26),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 77, 64, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
