import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gezify/firebase_options.dart';
import 'package:gezify/presentation/calander/bloc/event_bloc.dart';
import 'package:gezify/presentation/calander/data/event_repo.dart';
import 'package:gezify/presentation/comment/bloc/comment_bloc.dart';
import 'package:gezify/presentation/comment/data/comment_repo.dart';
import 'package:gezify/presentation/create_route/bloc/public_routes/public_routes_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/public_routes/public_routes_event.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/save_routes/save_routes_event.dart';
import 'package:gezify/presentation/home/data/category_repository.dart';
import 'package:gezify/presentation/home/presentation/cubits/category/category_bloc.dart';
import 'package:gezify/presentation/maps/bloc/map_screen_cubit.dart';
import 'package:gezify/presentation/splash/pages/onboarding_page.dart';
import 'package:gezify/presentation/splash/pages/splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gezify/presentation/auth/data/firebase_auth_repo.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/pages/auth_page.dart';
import 'package:gezify/presentation/home/data/destination_repository.dart';
import 'package:gezify/presentation/home/presentation/cubits/destination/destination_cubit.dart';
import 'package:gezify/presentation/home/presentation/cubits/navigation/navigation_cubit.dart';
import 'package:gezify/presentation/home/presentation/pages/home_page.dart';

import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('tr', null);
  await Geolocator.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = FirebaseAuthRepo();
    final firestore = FirebaseFirestore.instance;
    final categoryRepo = CategoryRepository(firestore: firestore);
    final auth = FirebaseAuth.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(authRepo: authRepo)),
        BlocProvider(
            create: (context) => AuthCubit(authRepo: authRepo)..checkUser()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(
          create: (context) => DestinationCubit(
            repository:
                DestinationRepository(firestore: FirebaseFirestore.instance),
          )..loadBestDestinations(),
        ),
        BlocProvider(create: (context) => RouteBloc()),
        BlocProvider<CategoryCubit>(
          create: (context) =>
              CategoryCubit(repository: categoryRepo)..fetchCategories(),
        ),
        BlocProvider<GoogleMapCubit>(
          create: (_) => GoogleMapCubit(),
        ),
        BlocProvider(
          create: (_) => CommentBloc(commentRepository: CommentRepository()),
        ),
        BlocProvider(
          create: (context) =>
              PublicRouteBloc(firestore: FirebaseFirestore.instance)
                ..add(LoadPublicRoutes()),
        ),
        BlocProvider(
          create: (_) => SaveRouteBloc(firestore: firestore, auth: auth)
            ..add(LoadSavedRoutes()),
        ),
        BlocProvider<EventBloc>(
          create: (_) => EventBloc(EventRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/auth': (context) => const AuthPage(),
          '/splash': (context) => const SplashPage(),
          // varsa onboarding ekle:
          '/onboarding': (context) => const OnboardingPage(),
        },
      ),
    );
  }
}
