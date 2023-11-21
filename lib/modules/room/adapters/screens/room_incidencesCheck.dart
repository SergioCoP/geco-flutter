// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

// ignore: must_be_immutable
class RoomIncidencesCheck extends StatelessWidget {
  RoomIncidencesCheck({super.key});
  TextStyle textoLabel = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold 
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Revisar incidencia'),
          backgroundColor: ColorsApp.primaryColor,
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
                    margin: EdgeInsets.only(bottom: 25.0,),
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
                              border: Border.all(color: Colors.red, width: 1.0)),
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
                        Text('Limpieza realizada por:',),
                        Text('Mario Alberto Quiñonez Bahena:'),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Limpieza por:'),
                          Text('Mario Alberto Quiñonez Bahena:'),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text('Evidencia:'),
                        Image.asset('assets/images/miku.jpg'),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('Marcar como completada')),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
