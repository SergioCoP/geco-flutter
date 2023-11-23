import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/validations/validations_app.dart';
import 'package:geco_mobile/modules/user/entities/user.dart';

class UserUpdate extends StatefulWidget {
  const UserUpdate({super.key});

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  late User user;
  late bool hasData = false;
  bool _passVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isButtonDisabled = true;

  final TextEditingController _nombresController =
      TextEditingController(text: '');
  final TextEditingController _apellidoPaternoController =
      TextEditingController(text: '');
  final TextEditingController _apellidoMaternoController =
      TextEditingController(text: '');
  final TextEditingController _contraseniaController =
      TextEditingController(text: '');
  final TextEditingController _contraseniaConfirmController =
      TextEditingController(text: '');
  final TextEditingController _correoController =
      TextEditingController(text: '');
  int _rolSeleccionado = 3;
  List<Map<String, dynamic>> listaRoles = [
    {'idRol': 2, 'description': 'Recepcionista'},
    {'idRol': 3, 'description': 'Personal de limpieza'},
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
    print('${GlobalData.pathUserUri}/getUserById?idUser=$idUser');
    try {
      final response =
          await dio.get('${GlobalData.pathUserUri}/getUserById?idUser=$idUser');

      if (response.data['msg'] == 'OK') {
        final userData = response.data['data'];
        setState(() {
          user = User(
            userData['idUser'] ?? idUser,
            userData['status'] ?? 0,
            userData['userName'] ?? '',
            userData['email'] ?? '',
            userData['password'] ?? '',
            userData['turn'] ?? '',
            userData['rolName'] ?? '',
            userData['idRol'],
            userData['idHotel'] ?? 0,
          );
          user.name = userData['name'];
          user.lastname = userData['lastname'];
          user.surname = userData['surname'];
          hasData = true;
        });
      }
    } catch (e) {
      print(e);
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
          title: const Text('Editar usuario'),
          backgroundColor: ColorsApp.primaryColor,
        ),
        body: hasData
            ? SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Center(
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
                                    initialValue: user.name,
                                    // controller: _nombresController,
                                    decoration: InputDecoration(
                                      labelText: 'Nombres',
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
                                    initialValue: user.lastname,
                                    decoration: InputDecoration(
                                      labelText: 'Apellido Paterno',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  sizedBox,
                                  TextFormField(
                                    initialValue: user.surname,
                                    decoration: InputDecoration(
                                      labelText: 'Apellido Materno',
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
                                      labelText: 'Correo',
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
                                  TextFormField(
                                    initialValue: user.password,
                                    // controller: _contraseniaController,
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(_passVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _passVisible = !_passVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                      return null;
                                    },
                                  ),
                                  sizedBox,
                                  DropdownButtonFormField<int>(
                                    decoration: const InputDecoration(
                                        labelText: 'Tipo de usuario'),
                                    value: _rolSeleccionado,
                                    items: listaRoles
                                        .map((rol) => DropdownMenuItem<int>(
                                              value: rol['idRol'],
                                              child: Text(rol['description']),
                                            ))
                                        .toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _rolSeleccionado = newValue!;
                                      });
                                    },
                                  ),
                                  sizedBox,
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorsApp.thirColor,
                                      ),
                                      onPressed: _isButtonDisabled
                                          ? null
                                          : () async {
                                              print(
                                                  'userName: ${user.userName}');

                                              // const path = GlobalData.pathUri;
                                              // final dio = Dio();
                                              // final response = await dio.post('$path/registerUser', data: {
                                              //   'nombres': _nombresController.text,
                                              //   'apellido_paterno': _apellidoPaternoController.text,
                                              //   'apellido_materno': _apellidoMaternoController.text,
                                              //   'correo': _correoController.text,
                                              //   'contrasenia': _contraseniaController.text,
                                              //   'rol': _rolSeleccionado,
                                              // });
                                              // if (response.statusCode == 200) {
                                              //   // Mostrar un toast de registro exitoso
                                              //   Fluttertoast.showToast(
                                              //     msg: 'Registro exitoso',
                                              //     toastLength: Toast.LENGTH_SHORT,
                                              //     gravity: ToastGravity.CENTER,
                                              //     backgroundColor: Color(0xFF589F56),
                                              //     textColor: Colors.white,
                                              //     fontSize: 16.0,
                                              //   );
                                              // } else {
                                              //   Fluttertoast.showToast(
                                              //     msg: 'Error en el registro',
                                              //     toastLength: Toast.LENGTH_SHORT,
                                              //     gravity: ToastGravity.CENTER,
                                              //     backgroundColor: Colors.red,
                                              //     textColor: Colors.white,
                                              //     fontSize: 16.0,
                                              //   );
                                              // }
                                              Navigator.of(context).pushNamed(
                                                  '/manager/check_rooms');
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
                    )),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
