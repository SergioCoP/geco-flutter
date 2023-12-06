import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class UserRoom extends StatefulWidget {
  const UserRoom({Key? key}) : super(key: key);

  @override
  _UserRoomState createState() => _UserRoomState();
}

class _UserRoomState extends State<UserRoom> {
  late int userId;

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Habitaciones asignadas'),
      backgroundColor: ColorsApp.primaryColor,
    );
  }

  @override
  void initState() {
    super.initState();
    final dynamic rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArgs as Map<String, dynamic>?) ?? {};
    userId = arguments['idUser'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(),
      // Otros widgets y lógica de construcción de la interfaz de usuario
    );
  }
}
