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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/back_img.jpg',
                ),
                fit: BoxFit.cover)),
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
                    MaterialPageRoute(builder: (_) => RouteView()),
                  );
                },
              ),
              const SizedBox(height: 25),
              _glassButton(
                context,
                icon: Icons.favorite_border,
                title: "Herkese Açık Rotalar",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicRouteListPage(),
                      ));
                },
              ),
              const SizedBox(height: 25),
              _glassButton(
                context,
                icon: Icons.save_rounded,
                title: "Kaydedilen Rotalar",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaveRouteListPage(),
                      ));
                },
              ),
              const SizedBox(height: 25),
              _glassButton(
                context,
                icon: Icons.list_alt,
                title: "Benim Rotalarım",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyRoutesPage(),
                      ));
                },
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
              border: Border.all(color: Colors.black.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.black, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
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
