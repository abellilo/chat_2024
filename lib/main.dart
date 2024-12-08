
import 'package:chat_2024/firebase_options.dart';
import 'package:chat_2024/screens/login_page.dart';
import 'package:chat_2024/screens/register_page.dart';
import 'package:chat_2024/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth/auth_gate.dart';
import 'services/login_or_register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthServices())
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat {Lilo}',
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
