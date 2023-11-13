import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/widgets/splash/splash.dart';
import 'package:geco_mobile/modules/login/adapters/screens/login.dart';
import 'package:geco_mobile/modules/register/adapters/screens/register_user.dart';
import 'package:geco_mobile/modules/user/adapters/screens/user_management.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
     return  MaterialApp(
      debugShowCheckedModeBanner: false,
     //Generar splash screen
     initialRoute: '/',
     routes: {
      '/': (context) => const Splash(legend: 'Cargando...'),
      '/login': (context) => const Login(),
      '/registerUser': (context) =>  RegisterUser(),
      '/users': (context) => const UserManagement(),
     },
    );
  }
}
