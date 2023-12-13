// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_management.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:geco_mobile/modules/gerente/user/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geco_mobile/kernel/theme/color_app.dart';

// ignore: must_be_immutable
class EditRoom extends StatefulWidget {
  const EditRoom({super.key});

  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  final dio = Dio();
  late Room room;
  late bool hasData = false;

  final _formKeyUpdateRoom = GlobalKey<FormState>();
  bool _isButtonDisabled = false;

  late List<Map<String, dynamic>> usersMatutinos = [
    {'id': 0, 'name': 'Seleccione un usuario'}
  ];
  late List<Map<String, dynamic>> usersVespertinos = [
    {'id': 0, 'name': 'Seleccione un usuario'}
  ];
  int userMatutinoSeleccionado = 0;
  int userVespertinoSeleccionado = 0;

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
  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;
  @override
  void initState() {
    super.initState();
    // fetchData();
    setColor();
  }

  void setColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? color11 = prefs.getString('primaryColor');
    String? color22 = prefs.getString('secondaryColor');
    setState(() {
      color1 = Color(int.parse(color11!));
      color2 = Color(int.parse(color22!));
    });
  }

  Future<void> fetchData(final idRoom) async {
    final dio = Dio();
    const pathRoom = GlobalData.pathRoomUri;
    const pathUsers = GlobalData.pathUserUri;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await dio.get('$pathRoom/$idRoom',
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
        print('Aqui la longitud de los users por room: ${users.length}');
        room = Room.fromJson(response.data['data'], users);

        final responseUsers = await dio.get(pathUsers,
            options: Options(headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token'
            }));
        if (responseUsers.data['status'] == 'OK') {
          List<User> listaUsuarios =
              User.fromListJson(responseUsers.data['data']);
          for (var user in listaUsuarios) {
            if (room.users.isNotEmpty) {
              if (room.users[0] != null) {
                userMatutinoSeleccionado = room.users[0].idUser!;
              }
              if (room.users[1] != null) {
                userVespertinoSeleccionado = room.users[1].idUser!;
              }
            }
            String fullname =
                '${user.idPerson?.name} ${user.idPerson?.surname} ${user.idPerson?.lastname ?? ''} ';
            final userMap = {'id': user.idUser, 'name': fullname};
            if (user.turn == 1) {
              usersMatutinos.add(userMap);
            } else if (user.turn == 2) {
              usersVespertinos.add(userMap);
            }
          }

          setState(() {
            hasData = true;
          });
        }
      }
    } on DioException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar traer al isuario. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } catch (e, f) {
      print('$e   ,   $f');
      Navigator.pop(context);
    }
  }

  void actualizarDatos(
    Room room,
    int user1,
    int user2,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idHotel = prefs.getInt('idHotel');
      Response response;
      response = await dio.post(GlobalData.pathRoomUri,
          data: {
            "idRoom": room.idRoom,
            "status": room.status,
            "name": room.name,
            "roomNumber": room.roomNumber,
            "idTypeRoom": {"idTypeRoom": room.idTypeRoom.idTypeRoom},
            "firstIdUser": {"idUser": userMatutinoSeleccionado},
            "secondIdUser": {"idUser": userVespertinoSeleccionado},
            "idHotel": {"idHotel": idHotel}
          },
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data["status"] == 'CREATED') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habitación actualizada exitosamente.'),
          ),
        );
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => const RoomManagement()),
        );
      }
    } on DioException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar traer al isuario. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
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
        backgroundColor: color1,
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
                            width: 0.5), // Añade un borde más marcado
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              initialValue: room.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor asigna un nombre a la habitación';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Nombre de habitación',
                                hintText: 'Nombre de habitación',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  room.name = value;
                                });
                              },
                            ),
                            const SizedBox(height: 30),
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
                            const SizedBox(height: 30),
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
                            const Text(
                              'Encargados de limpieza',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<int>(
                              value: userMatutinoSeleccionado,
                              items: usersMatutinos.map((user1) {
                                return DropdownMenuItem<int>(
                                    value: user1['id'],
                                    child: Text(user1['name']));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  userMatutinoSeleccionado = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Turno matutino',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            DropdownButtonFormField<int>(
                              value: userVespertinoSeleccionado,
                              items: usersVespertinos
                                  .map((user2) => DropdownMenuItem<int>(
                                      value: user2['id'],
                                      child: Text(user2['name'])))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  userVespertinoSeleccionado = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Turno vespertino',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsApp.buttonPrimaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  )),
                              onPressed: _isButtonDisabled
                                  ? null
                                  : () {
                                      actualizarDatos(
                                          room,
                                          userMatutinoSeleccionado,
                                          userVespertinoSeleccionado);
                                    },
                              child: const Text('Guardar Cambios'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
