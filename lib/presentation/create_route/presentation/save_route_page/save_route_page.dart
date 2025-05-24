import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_state.dart';

import 'package:gezify/presentation/create_route/data/route_model.dart';
import 'package:gezify/presentation/create_route/presentation/public_route_page/public_route_detail_page.dart';

class SaveRouteListPage extends StatelessWidget {
  const SaveRouteListPage({super.key});

  RouteList _mapToRouteList(Map<String, dynamic> data) {
    return RouteList(
      id: data['id'] ?? '',
      title: data['title'] ?? 'Başlıksız Rota',
      isPrivate: data['isPrivate'] ?? true,
      routes: List<dynamic>.from(data['routes'] ?? []),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kaydedilen Rotalar')),
      body: BlocBuilder<SaveRouteBloc, SaveRouteState>(
        builder: (context, state) {
          if (state is SaveRouteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedRoutesLoaded) {
            if (state.savedRoutes.isEmpty) {
              return const Center(child: Text('Henüz kaydedilmiş rota yok.'));
            }

            return ListView.builder(
              itemCount: state.savedRoutes.length,
              itemBuilder: (context, index) {
                final data = state.savedRoutes[index];
                final routeList = _mapToRouteList(data);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      routeList.title.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Kaydedilen Rota'),
                    leading: Icon(
                      routeList.isPrivate ? Icons.lock : Icons.public,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PublicRouteDetailPage(routeList: routeList),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is SaveRouteFailure) {
            return Center(child: Text('Hata: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
