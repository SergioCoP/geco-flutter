// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreateIncidence extends StatefulWidget {
  CreateIncidence({super.key});

  @override
  State<CreateIncidence> createState() => _CreateIncidenceState();
}

class _CreateIncidenceState extends State<CreateIncidence> {
  TextStyle textoLabel = TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold);
  int idUser = 0;
  bool hasData = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void traerDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('idUser');
    setState(() {
      idUser = id!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crea una incidencia'),
          backgroundColor: ColorsApp().primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 25.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'HAB-01',
                          style: TextStyle(
                              fontSize: 26.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Container(
                          width: 120,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              border:
                                  Border.all(color: Colors.red, width: 1.0)),
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                'Con incidencias',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer(),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Limpieza realizada por:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Mario Alberto Quiñonez Bahena:'),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Detalles de la incidencia:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."'),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text('Evidencia:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Image.asset('assets/images/miku.jpg'),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Marcar como completada')),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
