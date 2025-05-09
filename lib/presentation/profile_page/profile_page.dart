import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/profile_page/FAQ.dart';
import 'package:gezify/presentation/profile_page/personal_details_page.dart';
import 'package:gezify/presentation/profile_page/settings_dart';
import 'profile_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          AssetImage("assets/images/user-avatar.png"),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
                ...state.options.map((option) => _buildListTile(context, option)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title) {
    IconData icon;
    switch (title) {
      case "Profil":
        icon = Icons.people;
        break;
      case "Payment":
        icon = Icons.payment;
        break;
      case "Settings":
        icon = Icons.settings;
        break;
      case "FAQ":
        icon = Icons.help_outline;
        break;
      default:
        icon = Icons.circle;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      leading: Icon(icon, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.read<ProfileBloc>().add(OptionTapped(title));
        
        if (title == "Profil") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalDetailsPage(),
            ),
          );
        }
        if (title == "Settings") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
        }
        if (title == "FAQ") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FaqPage(),
            ),
          );
        }
      },
    );
  }
}
