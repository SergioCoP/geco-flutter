import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class RubrosManagement extends StatefulWidget {
  const RubrosManagement({super.key});

  @override
  State<RubrosManagement> createState() => _RubrosManagementState();
}

class _RubrosManagementState extends State<RubrosManagement> {
  final double heightOfFirstContainer = 100.0;
  void filtrarUsuario(String query) {
    query = query.toLowerCase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Rubros de evaluación'),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Stack(
        children: [
          Scaffold(
            body: Container(
              margin: const EdgeInsets.only(
                top: 100,
              ),
              child: const Center(
                child: Text('Vista de los rubros de evaluación'),
              ),
            ),
          ),
           Positioned(
            child: SizedBox(
              height: heightOfFirstContainer,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (text) {
                              filtrarUsuario(text.toString());
                            },
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.search),
                              labelText: 'Buscar un rubro',
                              hintText: 'Escribe para buscar un rubro de evalucación',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsApp.buttonPrimaryColor,
                            ),
                            onPressed: () {
                              // Navigator.of(context)
                              //     .pushNamed('/manager/users/register');
                            },
                            child: const Icon(Icons.add)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
