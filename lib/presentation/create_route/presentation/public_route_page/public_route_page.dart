import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/public_routes/public_routes_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/public_routes/public_routes_state.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_event.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_state.dart';
import 'package:gezify/presentation/create_route/data/route_model.dart';
import 'package:gezify/presentation/create_route/presentation/public_route_page/public_route_detail_page.dart';
import 'package:gezify/presentation/home/presentation/pages/home_page.dart';

class PublicRouteListPage extends StatefulWidget {
  const PublicRouteListPage({super.key});

  @override
  State<PublicRouteListPage> createState() => _PublicRouteListPageState();
}

class _PublicRouteListPageState extends State<PublicRouteListPage> {
  List<String> savedRouteIds = [];

  RouteList _mapToRouteList(Map<String, dynamic> data) {
    return RouteList(
      id: data['id'] ?? '',
      title: data['title'] ?? 'Başlıksız Rota',
      isPrivate: data['isPrivate'] ?? true,
      routes: List<dynamic>.from(data['routes'] ?? []),
    );
  }

  @override
  void initState() {
    super.initState();
    // Kaydedilmiş rotaları yükle
    context.read<SaveRouteBloc>().add(LoadSavedRoutes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5F2),
     appBar: AppBar(
          title: const Text('Herkese Açık Rotalar'),
          centerTitle: true,
          backgroundColor: const Color(0xFF004D40),
          foregroundColor: const Color(0xFFE8F5F2),
        ),
      
      body: MultiBlocListener(
        listeners: [
          BlocListener<SaveRouteBloc, SaveRouteState>(
            listener: (context, state) {
              if (state is SavedRoutesLoaded) {
                setState(() {
                  // Burada sadece ID listesini alıyoruz
                  savedRouteIds = state.savedRoutes
                      .map((route) => route['id'] as String)
                      .toList();
                });
              } else if (state is SaveRouteFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Hata: ${state.message}')),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<PublicRouteBloc, PublicRouteState>(
          builder: (context, state) {
            if (state is PublicRouteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PublicRouteLoaded) {
              if (state.publicRoutes.isEmpty) {
                return const Center(
                    child: Text('Hiç herkese açık rota bulunamadı.'));
              }

              return ListView.builder(
                itemCount: state.publicRoutes.length,
                itemBuilder: (context, index) {
                  final data = state.publicRoutes[index];
                  final routeList = _mapToRouteList(data);
                  final isSaved = savedRouteIds.contains(routeList.id);

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color.fromRGBO(0, 77, 64, 1), // Siyah kenarlık
                        width: 1.2,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        routeList.title.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Herkese Açık Rota'),
                      leading: Icon(
                        routeList.isPrivate ?   Icons.public: Icons.lock,
                        color: const Color(0xFF00796B),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined,
                          color: isSaved
                              ? const Color.fromARGB(255, 0, 176, 155)
                              : null,
                        ),
                        onPressed: () {
                          context
                              .read<SaveRouteBloc>()
                              .add(ToggleSaveRouteRequested(routeList));
                        },
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
            } else if (state is PublicRouteError) {
              return Center(child: Text('Hata: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
