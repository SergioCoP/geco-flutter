// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:geco_mobile/modules/gerente/rubros/entities/rubro.dart';

class RoomRevisionCheck extends StatefulWidget {
  const RoomRevisionCheck({super.key});

  @override
  State<RoomRevisionCheck> createState() => _RoomRevisionCheckState();
}

class _RoomRevisionCheckState extends State<RoomRevisionCheck> {
  late Room room;
  final dio = Dio();
  bool _isButtonDisabled = true;
  bool hasData = false;
  final _path = GlobalData.pathRoomUri;

  List<Map<String, int>> listEvaluationItems = [];
  List<Rubro> listaRubros = [];
  List<bool> rubrosValue = [];

  Future<void> getRoomFetch(final idRoom) async {
    try {
      Response response;
      response = await dio.get('$_path/$idRoom');
      if (response.data['status'] == 'OK') {
        Room room = Room.fromJson(response.data['data']);
        listaRubros = List.generate(room.idTypeRoom.rubros.length,
            (index) => room.idTypeRoom.rubros[index]);
        rubrosValue =
            List.generate(listaRubros.length, (index) => false);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  bool checValue = false;
  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArgs as Map<String, dynamic>?) ?? {};
    final idTypeRoom = arguments['idRoom'] ?? 0;
    if (!hasData) {
      getRoomFetch(idTypeRoom);
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Revisar habitación'),
          centerTitle: true,
          backgroundColor: ColorsApp.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5.0,
            color: Colors.white,
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
                            // border: Border.all(color: Colors.blue, width: 1.0),
                          ),
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
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsApp.secondaryColor,
                            foregroundColor: Colors.white),
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
