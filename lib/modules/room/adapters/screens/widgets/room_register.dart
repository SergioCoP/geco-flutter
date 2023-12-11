// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class RoomRegister extends StatefulWidget {
  const RoomRegister({super.key});

  @override
  State<RoomRegister> createState() => _RoomRegisterState();
}

class _RoomRegisterState extends State<RoomRegister> {
  final path = GlobalData.pathRoomUri;
  final _formKeyRoomRegister = GlobalKey<FormState>();

  final TextStyle textStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

  final TextEditingController _identificador = TextEditingController(text: '');

  final TextEditingController _cantidadInicial =
      TextEditingController(text: '');

  final TextEditingController _cantidad = TextEditingController(text: '');

  final TextEditingController _descripcion = TextEditingController(text: '');

  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar habitación"),
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKeyRoomRegister,
              onChanged: () {
                setState(() {
                  _isButtonDisabled =
                      !_formKeyRoomRegister.currentState!.validate();
                });
              },
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Identificador',
                        style: textStyle,
                      ),
                      Container(
                        //Input de identificador de habitacion
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'por ejemplo: HAB-0',
                              labelText:
                                  'Ingrese un identificador para la(s) habitación(es)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          keyboardType: TextInputType.text,
                          controller: _identificador,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor asigna un identificador';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        'Número inicial de habitaciones',
                        style: textStyle,
                      ),
                      Container(
                        ///Input de numero inicial de habitaciones
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Número inicial de habitaciones',
                              labelText: 'Número inicial de habitaciones',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          keyboardType: TextInputType.number,
                          controller: _cantidadInicial,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                0 > int.parse(value)) {
                              return 'Por favor asigna un valor mayor o igual a cero';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        'Cantidad de habitaciones',
                        style: textStyle,
                      ),
                      Container(
                        ///Input de cuantas habitaciones se quieren registrar
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Cantidad de habitaciones',
                              labelText:
                                  '¿Cuantas habitaciones quiere registrar?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          keyboardType: TextInputType.number,
                          controller: _cantidad,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                0 >= int.parse(value)) {
                              return 'Por favor asigna un valor';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        'Descripción',
                        style: textStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Descripcion',
                              labelText:
                                  'Ingrese una descripción a la habitación',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          maxLines: 5,
                          keyboardType: TextInputType.text,
                          controller: _descripcion,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor inserta un valor';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        //Aqui esta el fokin boton
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsApp.secondaryColor,
                          ),
                          onPressed: _isButtonDisabled
                              ? null
                              : () async {
                                  if (_formKeyRoomRegister.currentState!
                                      .validate()) {
                                    String identificador = _identificador.text;
                                    String numInit = _cantidadInicial.text;
                                    String numHab = _cantidad.text;
                                    try {
                                      final dio = Dio();
                                      Response response;
                                      response = await dio.post(
                                          '$path/saveRoom?nameInit=$identificador&numInit=$numInit&numHab=$numHab',
                                          data: {
                                            "identifier": identificador,
                                            'description': _descripcion.text,
                                            "status": 1,
                                          });
                                      if (response.data['msg'] == 'Register') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Registro completado exitosamente.')),
                                        );
                                        Navigator.of(context).popAndPushNamed(
                                            '/manager/check_rooms');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'No se pudo realizar la petición, verifique sus datos')),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'No se pudo realizar la petición, verifique sus datos')),
                                      );
                                    }
                                  }
                                },
                          child: const Text('Registrar habitaciones'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
