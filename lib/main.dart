import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/firebase_options.dart';
import 'package:gezify/presentation/auth/data/firebase_auth_repo.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';
import 'package:gezify/presentation/auth/presentation/pages/auth_page.dart';
import 'package:gezify/presentation/home/presentation/cubits/navigation_cubit.dart';
import 'package:gezify/presentation/home/presentation/pages/home_page.dart';
import 'package:gezify/presentation/spotify/cubits/spotify_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = FirebaseAuthRepo();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(authRepo: authRepo)),
        BlocProvider(
            create: (context) => AuthCubit(authRepo: authRepo)..checkUser()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => SpotifyCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            if (authState is Unauthenticated) {
              return AuthPage();
            }
            if (authState is Authanticated) {
              return HomePage();
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
