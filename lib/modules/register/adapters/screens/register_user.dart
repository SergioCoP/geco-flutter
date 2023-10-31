import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class RegisterUser extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  bool _isButtonDisabled = true;

  final TextEditingController _nombre = TextEditingController(text: '');

  final TextEditingController _aPaterno = TextEditingController(text: '');
  final TextEditingController _aMaterno = TextEditingController(text: '');
  final TextEditingController _correo = TextEditingController(text: '');
  final TextEditingController _contrasena = TextEditingController(text: '');
  final TextEditingController _confcontrasena = TextEditingController(text: '');
  final dio = Dio();
  RegisterUser({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 150,
          color: ColorsApp.primaryColor,
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
            color: ColorsApp.primaryColor,
            child: Card(
              margin: const EdgeInsets.all(15),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(children: [
                Form(
                  key: _formKey,
                  onChanged: () {},
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              keyboardType: TextInputType.text,
                              controller: _nombre,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Apellido Paterno",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              keyboardType: TextInputType.text,
                              controller: _aPaterno,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Apellido Materno",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              keyboardType: TextInputType.text,
                              controller: _aMaterno,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Correo",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              keyboardType: TextInputType.emailAddress,
                              controller: _correo,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Contraseña",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              keyboardType: TextInputType.text,
                              controller: _contrasena,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Confirmar contraseña",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              keyboardType: TextInputType.text,
                              controller: _confcontrasena,
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
                                              ColorsApp.secondaryColor),
                                      onPressed: () {},
                                      child: const Text('Registrar'),
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
        )
      ],
    ));
  }
}
