// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/toasts/toasts.dart';
import 'package:geco_mobile/kernel/widgets/navigation/menu_manager.dart';
import 'package:geco_mobile/kernel/widgets/navigation/menu_personal_cleaner.dart';
import 'package:geco_mobile/modules/gerente/room/adapters/screens/room_management.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterHotel extends StatefulWidget {
  const RegisterHotel({super.key});

  @override
  State<RegisterHotel> createState() => _RegisterHotelState();
}

class _RegisterHotelState extends State<RegisterHotel> {
  Color primaryColor = ColorsApp().primaryColor;
  Color secondaryColor = ColorsApp().secondaryColor;

  final _formKey = GlobalKey<FormState>();
  bool _isButtonDisabled = true;

  final TextEditingController _nombreHotel = TextEditingController(text: '');
  final dio = Dio();
  @override
  Widget build(BuildContext context) {
    final dynamic rawArguments = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> arguments =
        (rawArguments as Map<String, dynamic> ?? {});

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
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      onChanged: () {
                        setState(() {
                          _isButtonDisabled =
                              !_formKey.currentState!.validate();
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Text('Registro de hotel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Nombre del hotel",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
                                    keyboardType: TextInputType.text,
                                    controller: _nombreHotel,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: const Text('Paleta de colores',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  child: Wrap(
                                    spacing: 30,
                                    children: [
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(6),
                                      //   child: const ColoredBox(
                                      //     color: ColorsApp.primaryColor,
                                      //     child: SizedBox(
                                      //       width: 60,
                                      //       height: 60,
                                      //     ),
                                      //   ),
                                      // ),
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(6),
                                      //   child: const ColoredBox(
                                      //     color: ColorsApp.secondaryColor,
                                      //     child: SizedBox(
                                      //       width: 60,
                                      //       height: 60,
                                      //     ),
                                      //   ),
                                      // ),
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(6),
                                      //   child: const ColoredBox(
                                      //     color: ColorsApp.thirColor,
                                      //     child: SizedBox(
                                      //       width: 60,
                                      //       height: 60,
                                      //     ),
                                      //   ),
                                      // ),
                                      // ColorPicker(
                                      //   pickerColor: primaryColor,
                                      //   onColorChanged: (Color color) {
                                      //     setState(() {
                                      //       primaryColor = color;
                                      //     });
                                      //   },
                                      // ),
                                      ColorBox(
                                          color: primaryColor,
                                          onColorChanged: (color) {
                                            _onColorChanged(color, 1);
                                          }),
                                      ColorBox(
                                          color: secondaryColor,
                                          onColorChanged: (color) {
                                            _onColorChanged(color, 2);
                                          })
                                    ],
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
                                                      BorderRadius.circular(
                                                          14)),
                                              minimumSize: const Size(400, 60),
                                              backgroundColor:
                                                  ColorsApp().secondaryColor,
                                              foregroundColor: Colors.white),
                                          onPressed: _isButtonDisabled
                                              ? null
                                              : () async {
                                                  Response response;
                                                  String color1 =
                                                      primaryColor.toString();
                                                  color1 = color1.substring(
                                                      6, color1.length - 1);
                                                  String color2 =
                                                      secondaryColor.toString();
                                                  color2 = color2.substring(
                                                      6, color2.length - 1);
                                                  print(
                                                      ' Este es el color uno: $color1');
                                                  print(
                                                      ' Este es el color dos: $color2');
                                                  try {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    final dataHotel = {
                                                      "email": arguments[
                                                              'correoUs'] ??
                                                          '',
                                                      "password": arguments[
                                                              'contrasenaUs'] ??
                                                          '',
                                                      'username': arguments[
                                                              'username'] ??
                                                          '',
                                                      "idPerson": {
                                                        "name": arguments[
                                                                'nombreUs'] ??
                                                            '',
                                                        "surname": arguments[
                                                                'apellidoPa'] ??
                                                            '',
                                                        "lastname": arguments[
                                                                'apellidoMa'] ??
                                                            '',
                                                      },
                                                      'idHotel': {
                                                        "name":
                                                            _nombreHotel.text,
                                                        "imageUrl":
                                                            "https://i.pinimg.com/736x/5e/86/a8/5e86a8faa7260d858eb3b1b9fa4236bf.jpg",
                                                        "primaryColor": color1,
                                                        "secondaryColor": color2
                                                      }
                                                    };
                                                    response = await dio.post(
                                                        '${GlobalData.pathUserUri}/hotel',
                                                        data: dataHotel);
                                                    if (response
                                                            .data['status'] ==
                                                        'CREATED') {
                                                      final response2 =
                                                          await dio.post(
                                                              '${GlobalData.pathUserUri}/login',
                                                              data: {
                                                            'user': arguments[
                                                                'username'],
                                                            'password': arguments[
                                                                'contrasenaUs']
                                                          });
                                                      if (response2
                                                              .data['status'] ==
                                                          'OK') {
                                                        /*
                                                            prefs.setString(
                                                          'token', response.data['token']
                                                        );
                                                            */
                                                        if (response2.data[
                                                                    'user']
                                                                ['status'] ==
                                                            1) {
                                                          prefs.setInt(
                                                              'idHotel',
                                                              response2.data[
                                                                          'user']
                                                                      [
                                                                      'idHotel']
                                                                  ['idHotel']);

                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  '/manager');
                                                        } else {
                                                          //Usuario no activo
                                                          Navigator.popUntil(
                                                              context,
                                                              ModalRoute
                                                                  .withName(
                                                                      '/login'));
                                                        }
                                                      }
                                                    }
                                                  } catch (e) {
                                                    throw Exception(e);
                                                  }
                                                },
                                          child: const Text('Registrar'),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  void _onColorChanged(Color color, int boxNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: (newColor) {
                setState(() {
                  switch (boxNumber) {
                    case 1:
                      primaryColor = newColor;
                      break;
                    case 2:
                      secondaryColor = newColor;
                      break;
                  }
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class ColorBox extends StatelessWidget {
  final Color color;
  final Function(Color) onColorChanged;

  ColorBox({required this.color, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onColorChanged(color);
      },
      child: Container(
        width: 80,
        height: 80,
        color: color,
      ),
    );
  }
}
