import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/route_event.dart';
import 'package:gezify/presentation/create_route/route_state.dart';

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RouteBloc(),
      child: const RouteView(),
    );
  }
}

class RouteView extends StatelessWidget {
  const RouteView({super.key});

  void _editRouteNameDialog(
      BuildContext context, int index, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rota adını düzenle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Yeni isim'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<RouteBloc>().add(EditRoute(index, controller.text));
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rota Listeni Oluştur',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rotalarım',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  if (state.routes.isEmpty) {
                    return const Center(
                        child: Text('Henüz rota eklenmedi',
                            style: TextStyle(color: Colors.grey)));
                  }
                  return ReorderableListView.builder(
                    itemCount: state.routes.length,
                    onReorder: (oldIndex, newIndex) => context
                        .read<RouteBloc>()
                        .add(ReorderRoute(oldIndex, newIndex)),
                    itemBuilder: (context, index) {
                      return Card(
                        key: ValueKey(state.routes[index]),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          //leading: const Icon(Icons.drag_handle, color: Colors.grey),
                          title: Text(state.routes[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () => _editRouteNameDialog(
                                    context, index, state.routes[index]),
                              ),
                              const SizedBox(width: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => context
                                      .read<RouteBloc>()
                                      .add(RemoveRoute(index)),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                context.read<RouteBloc>().add(SaveRoutes());
              },
              icon: const Icon(Icons.save),
              label: const Text('Rotaları Kaydet'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<RouteBloc>().add(AddRoute()),
        icon: const Icon(Icons.add),
        label: const Text('Rota ekle'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
