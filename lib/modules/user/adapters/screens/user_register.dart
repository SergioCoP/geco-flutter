// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/validations/validations_app.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  SizedBox sizedBox = const SizedBox(
    height: 25.0,
  );
  bool _isButtonDisabled = true;
  bool _passVisible = true;

  final TextEditingController _nombresController =
      TextEditingController(text: '');
  final TextEditingController _apellidoPaternoController =
      TextEditingController(text: '');
  final TextEditingController _apellidoMaternoController =
      TextEditingController(text: '');
  final TextEditingController _contraseniaController =
      TextEditingController(text: '');
  final TextEditingController _correoController =
      TextEditingController(text: '');
  List<Map<String, dynamic>> listaRoles = [
    {'idRol': 2, 'description': 'Recepcionista'},
    {'idRol': 3, 'description': 'Personal de limpieza'},
  ];
  List<Map<String, dynamic>> listaRolesName = [
    {'idRol': 2, 'description': 'Recepcionista'},
    {'idRol': 3, 'description': 'Personal de limpieza'},
  ];
  int _rolSeleccionado = 3;

  final rolNames = {
    1: "Role_Gerente",
    2: "Role_Recepcionista",
    3: "Role_Limpieza"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar un usuario'),
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: Center(
              child: Card(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    onChanged: () {
                      setState(() {
                        _isButtonDisabled = !_formKey.currentState!.validate();
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: _nombresController,
                          decoration: InputDecoration(
                            labelText: 'Nombre(s)',
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
                          controller: _apellidoPaternoController,
                          decoration: InputDecoration(
                            labelText: 'Apellido Paterno',
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
                          controller: _apellidoMaternoController,
                          decoration: InputDecoration(
                            labelText: 'Apellido Materno',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        sizedBox,
                        TextFormField(
                          controller: _correoController,
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(ValidationsApp.email);
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
                          controller: _contraseniaController,
                          obscureText: _passVisible,
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
                          decoration: InputDecoration(
                            labelText: 'Tipo de usuario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: _rolSeleccionado,
                          items: listaRoles.map((rol) {
                            return DropdownMenuItem<int>(
                              value: rol['idRol'],
                              child: Text(rol['description']),
                            );
                          }).toList(),
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
                                    final dio = Dio();
                                    const path =
                                        '${GlobalData.pathUserUri}/registerUser';
                                    print(path);
                                    try {
                                      final response = await dio.post(
                                        path,
                                        data: {
                                          'email': _correoController.text,
                                          'password':
                                              _contraseniaController.text,
                                          'status': 1,
                                          'idPerson': {
                                            'name': _nombresController.text,
                                            'lastname':
                                                _apellidoPaternoController.text,
                                            'surname':
                                                _apellidoMaternoController.text
                                          },
                                          'idRol': _rolSeleccionado
                                          // {
                                          //   "idRol": _rolSeleccionado,
                                          //   "rolName": rolNames[_rolSeleccionado],
                                          // },
                                        },
                                      );
                                      if (response.data['msg'] == 'Register') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Usuario registrado exitosamente.')),
                                        );
                                        Navigator.of(context)
                                            .pushNamed('/manager/users');
                                      }
                                    } catch (e) {
                                      print(e);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'No se pudo registrar al usuario. intente de nuevo.')),
                                      );
                                    }
                                  },
                            child: const Text('Registrar usuario'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
