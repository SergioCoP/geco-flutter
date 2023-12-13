// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/validations/validations_app.dart';
import 'package:geco_mobile/modules/gerente/user/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUpdate extends StatefulWidget {
  const UserUpdate({super.key});

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  late User user;
  late bool hasData = false;
  // bool _passVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isButtonDisabled = true;
  int _rolSeleccionado = 3;
  int _turnoSeleccionado = 0;
  List<Map<String, dynamic>> listaRoles = [
    {'idRol': 2, 'description': 'Recepcionista'},
    {'idRol': 3, 'description': 'Personal de limpieza'},
  ];
  List<Map<String, dynamic>> turnos = [
    {'turn': 0, 'description': 'Sin asignar'},
    {'turn': 1, 'description': 'Matutino'},
    {'turn': 2, 'description': 'Vespertino'},
  ];
  SizedBox sizedBox = const SizedBox(
    height: 25.0,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData(final idUser) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await dio.get('${GlobalData.pathUserUri}/$idUser',
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));

      if (response.data['status'] == 'OK') {
        final userData = response.data['data'];
        setState(() {
          user = User.fromJson(userData);
          _rolSeleccionado = user.idRol!.idRol;
          _turnoSeleccionado = user.turn!;
          hasData = true;
        });
      }
    } on DioException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar consultar al usuario. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic rawArgs = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArgs as Map<String, dynamic>?) ?? {};
    final idUser = arguments['idUser'];
    if (!hasData) {
      fetchData(idUser);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsApp().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: hasData
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Actualizar usuario',
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          color: Colors.white,
                          child: Form(
                            key: _formKey,
                            onChanged: () {
                              setState(() {
                                _isButtonDisabled =
                                    !_formKey.currentState!.validate();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    initialValue: user.username,
                                    // controller: _nombresController,
                                    decoration: InputDecoration(
                                      labelText: 'Nombre de usuario',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Este campo es requerido';
                                      }
                                      return null;
                                    },
                                  ),
                                  sizedBox,
                                  TextFormField(
                                    initialValue: user.email,
                                    // controller: _correoController,
                                    decoration: InputDecoration(
                                      labelText: 'Correo electronico',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      RegExp regex =
                                          RegExp(ValidationsApp.email);
                                      if (value == null || value.isEmpty) {
                                        return 'Este campo es requerido';
                                      } else if (!regex.hasMatch(value)) {
                                        return 'Correo invalido';
                                      }
                                      return null;
                                    },
                                  ),
                                  sizedBox,
                                  user.idRol!.idRol != 1
                                      ? DropdownButtonFormField<int>(
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Selecciona el rol del usuario'),
                                          value: _rolSeleccionado,
                                          items: listaRoles
                                              .map((rol) =>
                                                  DropdownMenuItem<int>(
                                                    value: rol['idRol'],
                                                    child: Text(
                                                        rol['description']),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _rolSeleccionado = newValue!;
                                            });
                                          },
                                        )
                                      : const SizedBox(height: 20.0),
                                  sizedBox,
                                  user.idRol!.idRol != 1
                                      ? DropdownButtonFormField<int>(
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Selecciona el turno del usuario'),
                                          value: _turnoSeleccionado,
                                          items: turnos
                                              .map((turno) =>
                                                  DropdownMenuItem<int>(
                                                    value: turno['turn'],
                                                    child: Text(
                                                        turno['description']),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _turnoSeleccionado = newValue!;
                                            });
                                          },
                                        )
                                      : const SizedBox(
                                          height: 1.0,
                                        ),
                                  sizedBox,
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorsApp.buttonPrimaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          )),
                                      onPressed: _isButtonDisabled
                                          ? null
                                          : () async {
                                              try {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String? token =
                                                    prefs.getString('token');
                                                final dio = Dio();
                                                const path =
                                                    GlobalData.pathUserUri;
                                                final response = await dio.put(
                                                    path,
                                                    data: {
                                                      'idUser': user.idUser,
                                                      'email': user.email,
                                                      'username': user.username,
                                                      'turn':
                                                          _turnoSeleccionado,
                                                      'idRol': {
                                                        "idRol":
                                                            _rolSeleccionado,
                                                      },
                                                    },
                                                    options: Options(headers: {
                                                      "Accept":
                                                          "application/json",
                                                      "Content-Type":
                                                          "application/json",
                                                      'Authorization':
                                                          'Bearer $token'
                                                    }));
                                                if (response.data['status'] ==
                                                    'OK') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Usuario Actualizado exitosamente.')),
                                                  );
                                                  Navigator.of(context)
                                                      .popAndPushNamed(
                                                          '/manager');
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'No se pudo actualizar el usuario. Verifique sus datos.')),
                                                  );
                                                }
                                              } on DioException catch (e) {
                                                print(e);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Ha sucedido un error al intentar actualizar al usuario. Por favor intente mas tarde",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                Navigator.pop(context);
                                              } catch (e, f) {
                                                print('$e  ,  $f');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Ha sucedido un error al actualizar. Intente más tarde.')),
                                                );
                                              }
                                            },
                                      child: const Text('Modificar'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
