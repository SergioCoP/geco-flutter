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
  int _rolSeleccionado = 3;
  List<Map<String, dynamic>> listaRoles = [
    {'idRol': 2, 'description': 'Recepcionista'},
    {'idRol': 3, 'description': 'Personal de limpieza'},
  ];
  final rolNames = {
    1: "Role_Gerente",
    2: "Role_Recepcionista",
    3: "Role_Limpieza"
  };
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
          user.idPerson.name = userData['name'];
          user.idPerson.lastname = userData['lastname'];
          user.idPerson.surname = userData['surname'];
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
                                    initialValue: user.idPerson.name,
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
                                    initialValue: user.idPerson.lastname,
                                    decoration: InputDecoration(
                                      labelText: 'Apellido Paterno',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  sizedBox,
                                  TextFormField(
                                    initialValue: user.idPerson.surname,
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
                                        backgroundColor:
                                            ColorsApp.secondaryColor,
                                      ),
                                      onPressed: _isButtonDisabled
                                          ? null
                                          : () async {
                                              print('name: ${user.idPerson.name}');
                                              print(
                                                  'lastname: ${user.idPerson.lastname}');
                                              print('surname: ${user.idPerson.surname}');
                                              print('email: ${user.email}');
                                              print(
                                                  'password: ${user.password}');
                                              print(
                                                  'id del Rol: $_rolSeleccionado');
                                              try {
                                                final dio = Dio();
                                                const path =
                                                    '${GlobalData.pathUserUri}/registerUser';
                                                final response = await dio.post(
                                                  path,
                                                  data: {
                                                    'idUser': user.idUser,
                                                    
                                                    'email': user.email,
                                                    'password': user.password,
                                                    'status': user.status,
                                                    'idPerson': {
                                                      'name': user.idPerson.name,
                                                      'lastname': user.idPerson.lastname,
                                                      'surname': user.idPerson.surname
                                                    },
                                                    'idRol': _rolSeleccionado
                                                    // {
                                                    //   "idRol": _rolSeleccionado,
                                                    //   "rolName": rolNames[
                                                    //       _rolSeleccionado],
                                                    // },
                                                  },
                                                );
                                                if (response.data['msg'] ==
                                                    'Register') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Usuario registrado exitosamente.')),
                                                  );
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/manager/users');
                                                }
                                              } catch (e) {
                                                print(e);
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
                    )),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
