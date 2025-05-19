import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/profile/FAQ.dart';
import 'package:gezify/profile/personal_details_page.dart';
import 'package:gezify/profile/bloc/profile_bloc.dart';
import 'package:gezify/profile/bloc/profile_event.dart';
import 'package:gezify/profile/bloc/profile_state.dart';
import 'package:gezify/profile/settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocProvider(
      create: (_) => ProfileBloc(authCubit: authCubit)..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
          centerTitle: true,
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
                      "Gezify Üyesi",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
                ...state.options
                    .map((option) => _buildListTile(context, option)),
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
      case "Seyahat Geçmişi":
        icon = Icons.where_to_vote_rounded;
        break;
      case "Settings":
        icon = Icons.settings;
        break;
      case "FAQ":
        icon = Icons.help_outline;
        break;
      case "Çıkış Yap":
        icon = Icons.logout;
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
        } else if (title == "Settings") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
        } else if (title == "FAQ") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FaqPage(),
            ),
          );
        } else if (title == "Çıkış Yap") {
          showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Çıkış Yap'),
              content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Çıkış Yap'),
                ),
              ],
            ),
          ).then((shouldLogout) async {
            if (shouldLogout == true) {
              await context.read<AuthCubit>().logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }
            }
          });
        }
      },
    );
  }
}
