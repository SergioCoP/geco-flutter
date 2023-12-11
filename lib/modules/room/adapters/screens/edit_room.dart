// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
// import 'package:geco_mobile/kernel/theme/color_app.dart';

class RoomEdit {
  String identifier;
  int status;
  int idRoom;
  String description;
  int supervisor1;
  int supervisor2;

  RoomEdit({
    required this.idRoom,
    required this.identifier,
    required this.status,
    required this.description,
    required this.supervisor1,
    required this.supervisor2,
  });
}

// ignore: must_be_immutable
class EditRoom extends StatefulWidget {
  const EditRoom({super.key});

  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  late RoomEdit room;
  late RoomEdit room2;
  late bool hasData = false;

  final _formKeyUpdateRoom = GlobalKey<FormState>();
  bool _isButtonDisabled = false;

  late List<Map<String, dynamic>> supervisors = [
    {'id': 0, 'name': 'Seleccione un usuario'}
  ];
  List<Map<String, dynamic>> listaEstados = [
    {'status': 0, 'text': 'Deshabilitada'},
    {'status': 1, 'text': 'En venta'},
    {'status': 2, 'text': 'En uso'},
    {'status': 3, 'text': 'Sucia'},
    {'status': 4, 'text': 'Para revisar'},
    {'status': 5, 'text': 'Con incidencias'},
  ];
  int estadoActual = 0;
  String estadoSeleccionado = '0';
  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  Future<void> fetchData(final idRoom) async {
    print(idRoom);
    final dio = Dio();
    // try {
    final response = await dio
        .get('${GlobalData.pathRoomUri}/getRoomWithUserById?idRoom=$idRoom');
    if (response.data['msg'] == 'OK') {
      final roomData = response.data['data'];
      print(roomData);
      int sup1 = 0;
      int sup2 = 0;
      int contSups = 0;
      if (roomData['users'] != null) {
        for (var user in roomData['users']) {
          contSups++;
          if (contSups == 1) {
            sup1 = user['idUser'];
          } else if (contSups == 2) {
            sup2 = user['idUser'];
          } else {
            break;
          }
        }
      }
      room = RoomEdit(
          idRoom: roomData['idRoom'],
          identifier: roomData['identifier'],
          status: roomData['status'] ?? 0,
          description: roomData['description'] ?? 'Sin descripción',
          supervisor1: sup1,
          supervisor2: sup2);
      room2 = room;
      hasData = true;
    }
    final responseUsers = await dio
        .get('${GlobalData.pathUserUri}/getUsersByRol?rolName=Role_Limpieza');
    if (responseUsers.data['msg'] == 'OK') {
      print(responseUsers.data['data']);
      final usuariosLimpieza = responseUsers.data['data'];
      for (var user in usuariosLimpieza) {
        supervisors.add({'id': user['idUser'], 'name': user['userName']});
      }
    } else {
      supervisors = <Map<String, dynamic>>[
        {'id': 0, 'name': 'Selecciona in usuario'},
      ]; // Reempl
    }
    setState(() {
      hasData = true;
    });
    // } catch (error) {
    //   print(error);
    //   // Manejar el error de alguna manera
    // }
  }

  void actualizarDatos(RoomEdit room) async {
    print(room.idRoom);
    print(room.identifier);
    print(room.description);
    print(room.status);
    print(room.supervisor1);
    print(room.supervisor2);
    final dio = Dio();
    final request =
        await dio.put('${GlobalData.pathRoomUri}/updateRoom', data: {
      'idRoom': room.idRoom,
      'description': room.description,
      'status': room.status,
      'identifier': room.identifier
    });
    if (request.data['msg'] == 'Update') {
      if (room.supervisor1 != room2.supervisor1 &&
          room.supervisor2 != room2.supervisor2) {
        //Si hay modificacion en algun usuarios
        if (room.supervisor1 != room2.supervisor1) {
          final rsup1 = dio.post(
              '${GlobalData.pathRoomUri}/assignUserRoom?idUser=${room.supervisor1}&idRoom=${room.idRoom}');
          final rsup2 = dio.post(
              '${GlobalData.pathRoomUri}/assignUserRoom?idUser=${room.supervisor2}&idRoom=${room.idRoom}');
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actualización completada exitosamente.')),
      );
      Navigator.of(context).popAndPushNamed('/manager/check_rooms');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'No se pudo actualizar los datos. Por favor, verifique la información.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArgs as Map<String, dynamic>?) ?? {};
    final idRoom = arguments['idRoom'];
    if (!hasData) {
      fetchData(idRoom);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Habitación'),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: hasData
          ? Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKeyUpdateRoom,
                    onChanged: () {
                      setState(() {
                        _isButtonDisabled =
                            !_formKeyUpdateRoom.currentState!.validate();
                      });
                    },
                    child: Card(
                      elevation: 4.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Ajusta el radio del borde de la tarjeta
                        side: const BorderSide(
                            color: Colors.black,
                            width: 1.0), // Añade un borde más marcado
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              initialValue: room.identifier,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor asigna un identificador';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Identificador',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            // DropdownButtonFormField<int>(
                            //   value: room.status,
                            //   items: listaEstados
                            //       .map(
                            //         (estado) => DropdownMenuItem<int>(
                            //             value: estado['status'],
                            //             child: Text(estado['text'])),
                            //       )
                            //       .toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       room.status = value!;
                            //     });
                            //   },
                            //   decoration: InputDecoration(
                            //     labelText: 'Estado',
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 30),
                            // TextFormField(
                            //   initialValue: room.description,
                            //   maxLines: 5,
                            //   decoration: InputDecoration(
                            //     labelText: 'Descripción',
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 30),
                            Text(
                              'Encargados de limpieza',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 15),
                            DropdownButtonFormField<int>(
                              value: room.supervisor1,
                              items: supervisors.map((user1) {
                                return DropdownMenuItem<int>(
                                    value: user1['id'],
                                    child: Text(user1['name']));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  room.supervisor1 = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Turno matutino',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            DropdownButtonFormField<int>(
                              value: room.supervisor2,
                              items: supervisors
                                  .map((user2) => DropdownMenuItem<int>(
                                      value: user2['id'],
                                      child: Text(user2['name'])))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  room.supervisor2 = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Turno vespertino',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsApp.secondaryColor,
                                  foregroundColor: Colors.white),
                              onPressed: _isButtonDisabled
                                  ? null
                                  : () {
                                      actualizarDatos(room);
                                    },
                              child: Text('Guardar Cambios'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
