import 'package:flutter/material.dart';
import 'package:gezify/presentation/create_route/data/route_model.dart';
import 'package:gezify/presentation/create_route/presentation/line_route.dart';

class PublicRouteDetailPage extends StatelessWidget {
  final RouteList routeList;

  const PublicRouteDetailPage({super.key, required this.routeList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5F2),
      appBar: AppBar(
          title: const Text('Rota Detayı'),
          centerTitle: true,
          backgroundColor: const Color(0xFF004D40),
          foregroundColor: const Color(0xFFE8F5F2),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              routeList.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D40),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.lock_open, size: 18, color: Color(0xFF00796B)),
                SizedBox(width: 6),
                Text(
                  "Gizlilik: Herkese Açık",
                  style: TextStyle(
                    color: Color(0xFF00796B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.map, color: Color(0xFF004D40)),
                SizedBox(width: 6),
                Text(
                  "Rotalar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF004D40),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: routeList.routes.isEmpty
                  ? const Center(
                      child: Text(
                        "Bu rotada henüz bir konum eklenmemiş.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: routeList.routes.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.black12),
                      itemBuilder: (context, index) {
                        final item = routeList.routes[index];

                        if (item is String) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.location_on, color: Color(0xFF00796B)),
                            title: Text(
                              item,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        } else if (item is Map<String, dynamic>) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.place, color: Color(0xFF00796B)),
                            title: Text(
                              item['title'] ?? 'Bilinmeyen Konum',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LineRoutePage(routeData: routeList.routes),
                    ),
                  );
                },
                icon: const Icon(Icons.map_outlined,color: Color(0xFFE8F5F2),),
                label: const Text(
                  "Haritada Görüntüle",
                  style: TextStyle(fontSize: 16,
                  color: Color(0xFFE8F5F2),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
