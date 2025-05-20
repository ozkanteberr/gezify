import 'package:flutter/material.dart';
import 'package:gezify/presentation/create_route/data/route_model.dart';

class RouteDetailPage extends StatelessWidget {
  final RotaListesi routeList;

  const RouteDetailPage({super.key, required this.routeList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(routeList.listName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🔖 ${routeList.title}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "🔒 Gizlilik: ${routeList.isPrivate ? 'Özel' : 'Herkese Açık'}",
              style: TextStyle(
                color: routeList.isPrivate ? Colors.red : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "📍 Rotalar:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: routeList.routes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(routeList.routes[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
