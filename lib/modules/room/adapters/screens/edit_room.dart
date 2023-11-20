// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
// import 'package:geco_mobile/kernel/theme/color_app.dart';

class RoomEdit {
  String identifier;
  int status;
  String description;
  String supervisor1;
  String supervisor2;

  RoomEdit({
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
  late bool hasData = false;

  final _formKeyUpdateRoom = GlobalKey<FormState>();
  bool _isButtonDisabled = false;

  late List<Map<String, dynamic>> supervisors = [];
  List<Map<String, dynamic>> listaEstados = [
    {'status': 0, 'text': 'Deshabilitada'},
    {'status': 1, 'text': 'En venta'},
    {'status': 2, 'text': 'En uso'},
    {'status': 3, 'text': 'Sucia'},
    {'status': 4, 'text': 'Para revisar'},
    {'status': 5, 'text': 'Con incidencias'},
  ];
  int EstadoActual = 0;
  String estadoSeleccionado = '0';
  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  Future<void> fetchData(final idRoom) async {
    print(idRoom);
    final dio = Dio();
    try {
      final response =
          await dio.get('${GlobalData.pathRoomUri}/getRoom?idRoom=$idRoom');
      final responseUsers = await dio.get('${GlobalData.pathUserUri}/getUsers');
      if (response.data['msg'] == 'OK') {
        final roomData = response.data['data'];
        print(roomData);
        setState(() {
          room = RoomEdit(
            identifier: roomData['identifier'],
            status: roomData['status'],
            description: roomData['description'] ?? 'Sin descripción',
            supervisor1: roomData['supervisor1'] ?? '0',
            supervisor2: roomData['supervisor2'] ?? '1',
          );
          supervisors = <Map<String, dynamic>>[
            {'id': '0', 'name': 'Sergio'},
            {'id': '1', 'name': 'Alberto'},
            {'id': '2', 'name': 'Angel'},
          ]; // Reemplaza con tus datos reales
          hasData = true;
        });
      }
      if (responseUsers.data['msg'] == 'OK') {
        print(responseUsers.data['data']);
      }
    } catch (error) {
      print(error);
      // Manejar el error de alguna manera
    }
  }

  void actualizarDatos(RoomEdit room) async {
    print(room.identifier);
    print(room.description);
    print(room.status);
    print(room.supervisor1);
    print(room.supervisor2);
    // final dio = Dio();
    // final request =
    //     await dio.get('${GlobalData.pathRoomUri}/updateRoom', data: {});
    // if (request.data['msg' == 'Update']) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Actualización completada exitosamente.')),
    //   );
    //   Navigator.of(context).pop();
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('No se pudo actualizar los datos. Por favor, verifique la información.')),
    //   );
    // }
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
      ),
      body: hasData
          ? SingleChildScrollView(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          DropdownButtonFormField<int>(
                            value: room.status,
                            items: listaEstados
                                .map(
                                  (estado) => DropdownMenuItem<int>(
                                      value: estado['status'],
                                      child: Text(estado['text'])),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                room.status = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Estado',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            initialValue: room.description,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Descripción',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Encargados de limpieza',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: room.supervisor1,
                            items: supervisors.map((user1) {
                              return DropdownMenuItem<String>(
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
                          DropdownButtonFormField<String>(
                            value: room.supervisor2,
                            items: supervisors
                                .map((user2) => DropdownMenuItem<String>(
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
                            onPressed: _isButtonDisabled
                                ? null
                                : () {
                                    // Lógica para enviar los datos actualizados a la API
                                    // Puedes utilizar un paquete de manejo de estado o una función de callback según tus necesidades
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
