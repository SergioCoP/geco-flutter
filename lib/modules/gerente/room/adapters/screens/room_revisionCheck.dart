// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_dashboard.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:geco_mobile/modules/gerente/rubros/entities/rubro.dart';
import 'package:geco_mobile/modules/gerente/user/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool allClean = false;
  bool someClean = false;

  List<Map<String, int>> listEvaluationItems = [];
  List<Rubro> listaRubros = [];
  List<bool> rubrosValue = [];

  Future<void> getRoomFetch(final idRoom) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Response response;
      response = await dio.get('$_path/$idRoom',
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data['status'] == 'OK') {
        final data = response.data['data'];
        List<User> users = [];
        if (data['firstIdUser'] != null) {
          users.add(User.fromJson(data['firstIdUser']));
        }
        if (data['secondIdUser'] != null) {
          users.add(User.fromJson(data['secondIdUser']));
        }
        Room room = Room.fromJson(response.data['data'], users);
        listaRubros = List.generate(room.idTypeRoom.rubros.length,
            (index) => room.idTypeRoom.rubros[index]);
        print(listaRubros.length);
        rubrosValue = List.generate(listaRubros.length, (index) => false);
        setState(() {
          hasData = true;
        });
      }
    } catch (e) {
      throw Exception('Error al traer los datos asies que pendjo: $e');
    }
  }

  void updateStatus() async {
    int status = 1;
    int totalCheckeds = 0;
    int rubrosLength = listaRubros.length;
    bool allCheckeds = false;
    for (var rubro in rubrosValue) {
      if (rubro == true) {
        totalCheckeds += 1;
      }
    }
    if (totalCheckeds == rubrosLength) {
      //Si todos los puntos estan marcados
      allCheckeds = true;
    } else {
      //Si no todos los puntos estan marcados
      status = 5;
    }

    print('Estan todos los rubros checados?: $allCheckeds ');
    try {
      final data = {'status': 1};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Response response;
      response = await dio.put('$_path/status/${room.idRoom}',
          data: data,
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data['status'] == 'OK') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RoomsDashboard()));
      }
    } catch (e) {
      throw Exception('Error al traer los datos asies');
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
          backgroundColor: ColorsApp().primaryColor,
          foregroundColor: Colors.white,
        ),
        body: hasData
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold),
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
                        const SizedBox(height: 16.0),
                        Text(
                          'rubros de evaluación: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: List.generate(
                            listaRubros.length,
                            (index) {
                              Rubro rubro = listaRubros[index];
                              return CheckboxListTile(
                                title: Text(rubro.name),
                                value: rubrosValue[index],
                                onChanged: (value) {
                                  setState(() {
                                    rubrosValue[index] = value!;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsApp.buttonPrimaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  )),
                              onPressed: () {
                                updateStatus();
                              },
                              child: Text('Marcar como completada')),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
