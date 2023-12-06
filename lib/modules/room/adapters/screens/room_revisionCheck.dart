// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class RoomRevisionCheck extends StatefulWidget {
  const RoomRevisionCheck({super.key});

  @override
  State<RoomRevisionCheck> createState() => _RoomRevisionCheckState();
}

class _RoomRevisionCheckState extends State<RoomRevisionCheck> {
  bool checValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Revisar habtación'),
          centerTitle: true,
          backgroundColor: ColorsApp.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // textDirection: TextDirection.ltr,
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
                              color: ColorsApp.estadoSinRevisar,
                              border:
                                  Border.all(color: Colors.blue, width: 1.0)),
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                'Sin revisar',
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Limpieza realizada por:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Mario Alberto Quiñonez Bahena:'),
                      ],
                    ),
                  ),
                  SizedBox(
                    //CHEBOX QUE MOSTRARAN LOS RUBROS DE EVALUACIÓN
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'robros de evaluacion: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CheckboxListTile(
                            title: Text('Cama tendida'),
                            value: checValue,
                            onChanged: (newValue) {
                              setState(() {
                                checValue = newValue!;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text('Sábanas limpias'),
                            value: checValue,
                            onChanged: (newValue) {
                              setState(() {
                                checValue = newValue!;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text('Ventanas cerradas'),
                            value: checValue,
                            onChanged: (newValue) {
                              setState(() {
                                checValue = newValue!;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text('Baño limpio'),
                            value: checValue,
                            onChanged: (newValue) {
                              setState(() {
                                checValue = newValue!;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text('Cortinas limpias'),
                            value: checValue,
                            onChanged: (newValue) {
                              setState(() {
                                checValue = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Container(
                  //   padding: EdgeInsets.all(5.0),
                  //   child: Column(
                  //     children: [
                  //       Text('Evidencia:'),
                  //       Image.asset('assets/images/geco_logo.png'),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Descripción de la habitación:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Habitación del piso 1 lado derecho'),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsApp.secondaryColor,
                        ),
                        onPressed: () {},
                        child: Text('Marcar como revisada')),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
