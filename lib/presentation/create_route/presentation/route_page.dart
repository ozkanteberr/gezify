import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/route_event.dart';
import 'package:gezify/presentation/create_route/bloc/route_state.dart';
import 'package:gezify/presentation/create_route/presentation/route_detail.dart';

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

class RouteView extends StatefulWidget {
  const RouteView({super.key});

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  final TextEditingController _routeTitleController = TextEditingController();
  bool _isPrivate = false;

  @override
  void dispose() {
    //context.read<RouteBloc>().add(ClearRoutes());
    _routeTitleController.clear();
    _isPrivate = false;
    super.dispose();
  }

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
            onPressed: () => Navigator.pop(context),
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

  void _saveRoutes(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final title = _routeTitleController.text.trim();

    if (uid != null && title.isNotEmpty) {
      context.read<RouteBloc>().add(
            SaveRoutesToFirebase(
              uid: uid,
              listTitle: title,
              isPrivate: _isPrivate,
            ),
          );

      // Kaydettikten sonra formu ve durumu sıfırla
      context.read<RouteBloc>().add(ClearRoutes());
      _routeTitleController.clear();
      setState(() {
        _isPrivate = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rota listesi kaydedildi.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen başlık girin.")),
      );
    }
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rotalarım',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _routeTitleController,
              decoration: const InputDecoration(
                labelText: "Rota listesi başlığı (ör. Karadeniz Turu)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text("Herkese Açık mı?"),
                    const SizedBox(width: 10),
                    Switch(
                      value: !_isPrivate,
                      onChanged: (value) {
                        setState(() {
                          _isPrivate = !value;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => context.read<RouteBloc>().add(AddRoute()),
                  icon: const Icon(Icons.add),
                  label: const Text('Rota ekle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  if (state.routes.isEmpty) {
                    return const Center(
                      child: Text('Henüz rota eklenmedi',
                          style: TextStyle(color: Colors.grey)),
                    );
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
                          title: Text(state.routes[index]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RouteDetailPage(
                                  routeName: state.routes[index],
                                ),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () => _editRouteNameDialog(
                                    context, index, state.routes[index]),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => context
                                    .read<RouteBloc>()
                                    .add(RemoveRoute(index)),
                              ),
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
              onPressed: () => _saveRoutes(context),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
