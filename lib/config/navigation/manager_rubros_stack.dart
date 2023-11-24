import 'package:flutter/material.dart';
import 'package:geco_mobile/modules/rubros/adapters/screens/rubros_management.dart';

class ManagerRubrosStack extends StatelessWidget {
  const ManagerRubrosStack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/manager/rubros',
      routes: {
        '/manager/rubros': (context) => const RubrosManagement(),
      },
    );
  }
}