import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/widgets/splash/splash.dart';
import 'package:geco_mobile/modules/controlpanel/adapters/screens/control_panel.dart';
import 'package:geco_mobile/modules/login/adapters/screens/login.dart';
import 'package:geco_mobile/modules/register/adapters/screens/register_hotel.dart';
import 'package:geco_mobile/modules/register/adapters/screens/register_user.dart';
import 'package:geco_mobile/modules/user/adapters/screens/user_management.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      //Generar splash screen
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(legend: 'Cargando...'),
        '/login': (context) => const Login(),
        '/registerUser': (context) => const RegisterUser(),
        '/registerUserHotel': (context) => const RegisterHotel(),
        '/controlPanel': (context) => const ControlPanel(),
        '/users': (context) => const UserManagement()
      },
    );
  }
}
