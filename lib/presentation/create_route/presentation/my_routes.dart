import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_route_state.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_routes_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_routes_event.dart';
import 'package:gezify/presentation/create_route/presentation/my_route_detail_page.dart';
import 'package:gezify/presentation/create_route/presentation/route_directed.dart';

class MyRoutesPage extends StatelessWidget {
  const MyRoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyRoutesBloc()..add(FetchMyRoutes()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Oluşturduğum Rotalar")),
        body: BlocBuilder<MyRoutesBloc, MyRoutesState>(
          builder: (context, state) {
            if (state is MyRoutesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyRoutesLoaded) {
              if (state.routeLists.isEmpty) {
                return _buildEmptyMessage(context);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.routeLists.length,
                itemBuilder: (context, index) {
                  final routeList = state.routeLists[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        routeList.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text("📍 ${routeList.routes.length} rota"),
                          const SizedBox(height: 4),
                          Text(
                            routeList.isPrivate ? "🔒 Özel" : "🌍 Herkese Açık",
                            style: TextStyle(
                              color: routeList.isPrivate
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, routeList.id);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RouteDetailPage(routeList: routeList),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is MyRoutesError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Henüz rota oluşturulmamış.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteDirected(),
                  ));
            },
            icon: const Icon(Icons.add),
            label: const Text("Yeni Rota Oluştur"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          )
        ],
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, String routeId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Rotayı Sil"),
      content: const Text("Bu rotayı silmek istediğinizden emin misiniz?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<MyRoutesBloc>().add(DeleteRoute(routeId));
          },
          child: const Text("Sil"),
        ),
      ],
    ),
  );
}
