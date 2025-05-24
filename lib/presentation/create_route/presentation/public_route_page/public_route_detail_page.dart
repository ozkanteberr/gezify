import 'package:flutter/material.dart';
import 'package:gezify/presentation/create_route/data/route_model.dart';
import 'package:gezify/presentation/create_route/presentation/line_route.dart';

class PublicRouteDetailPage extends StatelessWidget {
  final RouteList routeList;

  const PublicRouteDetailPage({super.key, required this.routeList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rota Detayı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " ${routeList.title}".toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "🔒 Gizlilik: Herkese Açık",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "🗺️⁀✈︎  Rotalar:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: routeList.routes.isEmpty
                  ? const Text("Bu rotada henüz bir konum eklenmemiş.")
                  : ListView.builder(
                      itemCount: routeList.routes.length,
                      itemBuilder: (context, index) {
                        final item = routeList.routes[index];

                        if (item is String) {
                          return ListTile(
                            leading: Text('╰┈➤'),
                            title: Text(item),
                          );
                        } else if (item is Map<String, dynamic>) {
                          return ListTile(
                            leading: Text('╰┈➤'),
                            title: Text(
                              item['title'] ?? 'Bilinmeyen Konum',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LineRoutePage(routeData: routeList.routes),
                      ));
                },
                child: const Text("Haritada Görüntüle"))
          ],
        ),
      ),
    );
  }
}
