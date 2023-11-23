import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/user/adapters/screens/user_management.dart';
import 'package:geco_mobile/modules/user/adapters/screens/user_register.dart';
import 'package:geco_mobile/modules/user/adapters/screens/user_update.dart';

class ManagerUserStack extends StatelessWidget {
  const ManagerUserStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/manager/users',
      routes: {
        '/manager/users': (context) => const UserManagement(),
        '/manager/users/register': (context) => const UserRegister(),
        '/manager/users/update': (context) => const UserUpdate(),
      }
    );
  }
}