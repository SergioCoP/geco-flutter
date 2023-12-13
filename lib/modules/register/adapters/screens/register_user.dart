import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/toasts/toasts.dart';
import 'package:geco_mobile/kernel/validations/validations_app.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterUser();
}

class _RegisterUser extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();

  bool _isButtonDisabled = true;

  final TextEditingController _nombre = TextEditingController(text: '');
  final TextEditingController _usuario = TextEditingController(text: '');

  final TextEditingController _aPaterno = TextEditingController(text: '');
  final TextEditingController _aMaterno = TextEditingController(text: '');
  final TextEditingController _correo = TextEditingController(text: '');
  final TextEditingController _contrasena = TextEditingController(text: '');
  final TextEditingController _confcontrasena = TextEditingController(text: '');
  final dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 150,
          color: ColorsApp().primaryColor,
          child: Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(48),
                child: Image.asset(
                  'assets/images/geco_logo.png',
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: ColorsApp().primaryColor,
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    onChanged: () {
                      setState(() {
                        _isButtonDisabled = !_formKey.currentState!.validate();
                      });
                    },
                    child: Column(
                      children: <Container>[
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(children: [
                            const Text(
                              'Registro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Nombre",
                                    labelText: 'Nombre',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.text,
                                controller: _nombre,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Apellido Paterno",
                                    labelText: "Apellido Paterno",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.text,
                                controller: _aPaterno,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Apellido Materno",
                                    labelText: "Apellido Materno",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.text,
                                controller: _aMaterno,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Nombre de usuario",
                                    labelText: "Nombre de usuario",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.text,
                                controller: _usuario,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Correo electrónico",
                                    labelText: 'Correo electrónico',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.emailAddress,
                                controller: _correo,
                                validator: (val) {
                                  RegExp regex = RegExp(ValidationsApp.email);
                                  if (val!.isEmpty) {
                                    return 'Campo obligatorio';
                                  } else if (!regex.hasMatch(val)) {
                                    return 'Correo invalido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Contraseña",
                                    labelText: "Contraseña",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.text,
                                controller: _contrasena,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Confirmar contraseña",
                                    labelText: "Confirmar contraseña",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.text,
                                controller: _confcontrasena,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Campo obligatorio';
                                  } else if (val != _contrasena.text) {
                                    return 'Las contraseñas no coinciden';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14)),
                                            minimumSize: const Size(400, 60),
                                            backgroundColor:
                                                ColorsApp().secondaryColor),
                                        onPressed: _isButtonDisabled
                                            ? null
                                            : () async {
                                                Toasts.showSuccessToast(
                                                    'Registro de hotel');
                                                Navigator.pushNamed(context,
                                                    '/registerUserHotel',
                                                    arguments: {
                                                      'nombreUs': _nombre.text,
                                                      'apellidoPa':
                                                          _aPaterno.text,
                                                      'apellidoMa':
                                                          _aPaterno.text,
                                                      'username': _usuario.text,
                                                      'correoUs': _correo.text,
                                                      'contrasenaUs':
                                                          _contrasena.text
                                                    });
                                              },
                                        child:
                                            const Text('Ir a registro hotel'),
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
