import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/calander/bloc/event_bloc.dart';
import 'package:gezify/presentation/calander/bloc/event_event.dart';
import 'package:gezify/presentation/calander/bloc/event_state.dart';
import 'package:gezify/presentation/calander/model/event_model.dart';
import 'package:gezify/presentation/calander/widget/day_selctor.dart';
import 'package:gezify/presentation/calander/widget/event_tile.dart';
import 'package:gezify/presentation/home/presentation/pages/home_page.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    context.read<EventBloc>().add(LoadEvents(selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5F2),
      appBar: AppBar(
        title: const Text("Etkinlik Takvimi"),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: const Color(0xFFE8F5F2),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month,
                color: Color.fromRGBO(255, 255, 255, 1)),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
                context.read<EventBloc>().add(LoadEvents(selectedDate));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DaySelector(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                context.read<EventBloc>().add(LoadEvents(selectedDate));
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EventError) {
                    return Center(child: Text(state.message));
                  } else if (state is EventLoaded) {
                    if (state.events.isEmpty) {
                      return const Center(
                          child: Text("Bu gün için etkinlik yok."));
                    }

                    return ListView.builder(
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        return EventTile(event: state.events[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateEventSheet(context),
        backgroundColor: Color.fromRGBO(0, 77, 64, 1),
        label: const Text(
          "Etkinlik Oluştur",
          style:
              TextStyle(color: Color(0xFFE8F5F2)), // Buraya istediğin rengi yaz
        ),
        icon: const Icon(Icons.add,color: Color(0xFFE8F5F2)),
      ),
    );
  }

  void _showCreateEventSheet(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    DateTime eventDate = selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Etkinlik Oluştur", style: TextStyle(fontSize: 18)),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Etkinlik Adı"),
                ),
                ListTile(
                  title: Text("Tarih: ${DateFormat.yMd().format(eventDate)}"),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: eventDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => eventDate = picked);
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final event = EventModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        date: eventDate,
                      );
                      context.read<EventBloc>().add(AddEvent(event));
                      context.read<EventBloc>().add(LoadEvents(selectedDate));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Kaydet"),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        );
      },
    );
  }
}
