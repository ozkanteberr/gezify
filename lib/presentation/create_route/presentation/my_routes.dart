import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_route_state.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_routes_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/my_routes/my_routes_event.dart';
import 'package:gezify/presentation/create_route/presentation/my_route_detail_page.dart';
import 'package:gezify/presentation/create_route/presentation/route/route_directed.dart';

class MyRoutesPage extends StatelessWidget {
  const MyRoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyRoutesBloc()..add(FetchMyRoutes()),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5F2),
        appBar: AppBar(
          title: const Text(
            'Oluşturduğum Rotalar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF004D40),
          foregroundColor: const Color(0xFFE8F5F2),
          elevation: 0,
        ),
        body: BlocBuilder<MyRoutesBloc, MyRoutesState>(
          builder: (context, state) {
            if (state is MyRoutesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyRoutesLoaded) {
              if (state.routeLists.isEmpty) {
                return _buildEmptyMessage(context);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.routeLists.length,
                itemBuilder: (context, index) {
                  final routeList = state.routeLists[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      tileColor: Colors.white,
                      title: Text(
                        routeList.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined,
                                  size: 20, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text("${routeList.routes.length} rota"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                routeList.isPrivate
                                    ? Icons.lock_outline
                                    : Icons.public,
                                size: 20,
                                color: routeList.isPrivate
                                    ? Colors.redAccent
                                    : const Color(0xFF00796B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                routeList.isPrivate ? "Özel" : "Herkese Açık",
                                style: TextStyle(
                                  color: routeList.isPrivate
                                      ? Colors.redAccent
                                      : const Color(0xFF00796B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
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
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteDirected(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Yeni Rota Oluştur"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
      backgroundColor: Color(0xFFE8F5F2),
      title: const Text("Rotayı Sil"),
      content: const Text("Bu rotayı silmek istediğinizden emin misiniz?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "İptal",
            style: TextStyle(color: Color.fromRGBO(0, 77, 64, 1)), // veya istediğin renk
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<MyRoutesBloc>().add(DeleteRoute(routeId));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(0, 77, 64, 1),
          ),
          child: const Text(
            "Sil",
            style: TextStyle(color: Colors.white), // veya istediğin renk
          ),
        ),
      ],
    ),
  );
}
