import 'package:flutter/material.dart';

class PendientRooms extends StatelessWidget {
  const PendientRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis habitaciones')),
      body: const Center(
        child: Text('Aqui estarán las habitaciones que le corresponden al personal'),
      ),
    );
  }
}