import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipenca_mobile/firebase_options.dart';
import 'package:sipenca_mobile/screens/admin/admin.dart';
import 'package:sipenca_mobile/screens/auth/login.dart';
import 'package:sipenca_mobile/screens/auth/register.dart';
import 'package:sipenca_mobile/screens/petugas/petugas.dart';
import 'package:sipenca_mobile/screens/warga/warga.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: "Poppins"),
      home: const LoginPage(),
      routes: <String, WidgetBuilder>{
        '/warga': (context) => const MyHomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/petugas': (context) => const ListPengungsi(),
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}
