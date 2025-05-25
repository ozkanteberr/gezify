import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/presentation/profile/FAQ.dart';
import 'package:gezify/presentation/profile/bloc/profile_bloc.dart';
import 'package:gezify/presentation/profile/bloc/profile_event.dart';
import 'package:gezify/presentation/profile/bloc/profile_state.dart';
import 'package:gezify/presentation/profile/contact_page.dart';
import 'package:gezify/presentation/profile/personal_details_page.dart';
import 'package:gezify/presentation/profile/settings.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocProvider(
      create: (_) => ProfileBloc(authCubit: authCubit)..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5F2),
        appBar: AppBar(
          title: const Text('Profil'),
          centerTitle: true,
          backgroundColor: const Color(0xFF004D40),
          foregroundColor: const Color(0xFFE8F5F2),
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
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      backgroundColor: Color.fromRGBO(0, 77, 64, 1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F3E46),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Gezify Üyesi",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
                ...state.options
                    .map((title) => _buildProfileCard(context, title)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String title) {
    IconData icon;
    Color avatarColor;

    switch (title) {
      case "Profil":
        icon = Icons.person;
        avatarColor = const Color(0xFFE8F5F2); // açık mavi
        break;
      case "İletişim":
        icon = Icons.mail_outline;
        avatarColor = const Color(0xFFE8F5F2); // sarımsı
        break;
      case "Settings":
        icon = Icons.settings;
        avatarColor = const Color(0xFFE8F5F2); // mor
        break;
      case "FAQ":
        icon = Icons.help_center;
        avatarColor = const Color(0xFFE8F5F2); // sarı-açık turuncu
        break;
      case "Çıkış Yap":
        icon = Icons.logout;
        avatarColor = const Color(0xFFE8F5F2); // açık kırmızı
        break;
      default:
        icon = Icons.circle;
        avatarColor = Colors.grey.shade200;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 13),
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarColor, // Aynı rengi kullanabilirsin
            border: Border.all(color: Color.fromRGBO(0, 77, 64, 1), width: 1),
          ),
          child: Icon(icon, color: const Color(0xFF2F3E46)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF2F3E46),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Color(0xFF004D40)),
        onTap: () {
          context.read<ProfileBloc>().add(OptionTapped(title));

          if (title == "Profil") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalDetailsPage(),
              ),
            );
          } else if (title == "İletişim") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactPage(),
              ),
            );
          }
          else if (title == "Settings") {
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
                content:
                    const Text('Çıkış yapmak istediğinizden emin misiniz?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('İptal',
                        style: TextStyle(color: Color(0xFF2F3E46))),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Çıkış Yap',
                        style: TextStyle(color: Color(0xFFD32F2F))),
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
      ),
    );
  }
}
