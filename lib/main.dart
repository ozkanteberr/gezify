import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/configs/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
