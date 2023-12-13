// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomRegister extends StatefulWidget {
  const RoomRegister({super.key});

  @override
  State<RoomRegister> createState() => _RoomRegisterState();
}

class _RoomRegisterState extends State<RoomRegister> {
  final _pathRoom = GlobalData.pathRoomUri;
  final _pathTypeRoom = GlobalData.pathTypeRoomUri;
  final dio = Dio();
  final _formKeyRoomRegister = GlobalKey<FormState>();
  bool hasData = false;
  bool hasError = false;

  late List<Map<String, dynamic>> tiposRoom = [
    {'idTypeRoom': 0, 'name': 'Seleccione un tipo de habitación'}
  ];
  int tiposRoomSeleccionado = 0;

  bool _isSelectedUserZero = true;
  bool _isButtonDisabled = true;
  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;
  @override
  void initState() {
    super.initState();
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

  Future<void> traerTiposRoomFetch() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idHotel = prefs.getInt('idHotel');
      final response = await dio.get(_pathTypeRoom,
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      if (response.data['status'] == 'OK') {
        List<dynamic> traerTipos = response.data['data'];
        for (var typeRoom in traerTipos) {
          if (typeRoom['idHotel']['idHotel'] == idHotel) {
            tiposRoom.add({
              'idTypeRoom': typeRoom['idTypeRoom'],
              'name': typeRoom['name'],
            });
          }
        }
        setState(() {
          hasData = true;
        });
      }
    } on DioException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar traer los tipos de habitación. Por favor intente mas tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        hasData = true;
        hasError = true;
      });
      throw Exception(e);
    }
  }

  final TextStyle textStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

  // final TextEditingController _identificador = TextEditingController(text: '');

  // final TextEditingController _cantidadInicial =
  //     TextEditingController(text: '');

  // final TextEditingController _cantidad = TextEditingController(text: '');

  // final TextEditingController _descripcion = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    if (!hasData) {
      traerTiposRoomFetch();
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registrar habitación"),
          backgroundColor: color1,
          foregroundColor: Colors.white,
        ),
        body: hasData
            ? Center(
                child: SingleChildScrollView(
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Text(
                                //   'Identificador',
                                //   style: textStyle,
                                // ),
                                // Container(
                                //   //Input de identificador de habitacion
                                //   margin: const EdgeInsets.only(top: 12, bottom: 12),
                                //   child: TextFormField(
                                //     decoration: InputDecoration(
                                //         hintText: 'por ejemplo: HAB-0',
                                //         labelText:
                                //             'Ingrese un identificador para la(s) habitación(es)',
                                //         border: OutlineInputBorder(
                                //           borderRadius: BorderRadius.circular(15),
                                //         )),
                                //     keyboardType: TextInputType.text,
                                //     controller: _identificador,
                                //     // The validator receives the text that the user has entered.
                                //     validator: (value) {
                                //       if (value == null || value.isEmpty) {
                                //         return 'Por favor asigna un identificador';
                                //       }
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                // Text(
                                //   'Número inicial de habitaciones',
                                //   style: textStyle,
                                // ),
                                // Container(
                                //   ///Input de numero inicial de habitaciones
                                //   margin: const EdgeInsets.only(top: 12, bottom: 12),
                                //   child: TextFormField(
                                //     decoration: InputDecoration(
                                //         hintText: 'Número inicial de habitaciones',
                                //         labelText: 'Número inicial de habitaciones',
                                //         border: OutlineInputBorder(
                                //           borderRadius: BorderRadius.circular(15),
                                //         )),
                                //     keyboardType: TextInputType.number,
                                //     controller: _cantidadInicial,
                                //     // The validator receives the text that the user has entered.
                                //     validator: (value) {
                                //       if (value == null ||
                                //           value.isEmpty ||
                                //           0 > int.parse(value)) {
                                //         return 'Por favor asigna un valor mayor o igual a cero';
                                //       }
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                // Text(
                                //   'Cantidad de habitaciones',
                                //   style: textStyle,
                                // ),
                                // Container(
                                //   ///Input de cuantas habitaciones se quieren registrar
                                //   margin: const EdgeInsets.only(top: 12, bottom: 12),
                                //   child: TextFormField(
                                //     decoration: InputDecoration(
                                //         hintText: 'Cantidad de habitaciones',
                                //         labelText:
                                //             '¿Cuantas habitaciones quiere registrar?',
                                //         border: OutlineInputBorder(
                                //           borderRadius: BorderRadius.circular(15),
                                //         )),
                                //     keyboardType: TextInputType.number,
                                //     controller: _cantidad,
                                //     // The validator receives the text that the user has entered.
                                //     validator: (value) {
                                //       if (value == null ||
                                //           value.isEmpty ||
                                //           0 >= int.parse(value)) {
                                //         return 'Por favor asigna un valor';
                                //       }
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                // Text(
                                //   'Descripción',
                                //   style: textStyle,
                                // ),
                                // Container(
                                //   margin: const EdgeInsets.only(top: 12, bottom: 12),
                                //   child: TextFormField(
                                //     decoration: InputDecoration(
                                //         hintText: 'Descripcion',
                                //         labelText:
                                //             'Ingrese una descripción a la habitación',
                                //         border: OutlineInputBorder(
                                //           borderRadius: BorderRadius.circular(15),
                                //         )),
                                //     maxLines: 5,
                                //     keyboardType: TextInputType.text,
                                //     controller: _descripcion,
                                //     // The validator receives the text that the user has entered.
                                //     validator: (value) {
                                //       if (value == null || value.isEmpty) {
                                //         return 'Por favor inserta un valor';
                                //       }
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                Text(
                                  'Selecciona un tipo de cuarto para la habitación',
                                  style: textStyle,
                                ),
                                DropdownButtonFormField(
                                    value: tiposRoomSeleccionado,
                                    items: tiposRoom.map((tpRoom) {
                                      return DropdownMenuItem<int>(
                                          value: tpRoom['idTypeRoom'],
                                          child: Text(tpRoom['name']));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != 0) {
                                          _isSelectedUserZero = false;
                                        } else {
                                          _isSelectedUserZero = true;
                                        }
                                        tiposRoomSeleccionado = value!;
                                      });
                                    }),
                                Padding(
                                  //Aqui esta el fokin boton
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                                        : _isSelectedUserZero
                                            ? null
                                            : () async {
                                                try {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  String? token =
                                                      prefs.getString('token');
                                                  int? idHotel =
                                                      prefs.getInt('idHotel');
                                                  Response response;
                                                  response = await dio.post(
                                                      _pathRoom,
                                                      data: {
                                                        "idTypeRoom": {
                                                          "idTypeRoom":
                                                              tiposRoomSeleccionado
                                                        },
                                                        "idHotel": {
                                                          "idHotel": idHotel
                                                        }
                                                      },
                                                      options:
                                                          Options(headers: {
                                                        "Accept":
                                                            "application/json",
                                                        "Content-Type":
                                                            "application/json",
                                                        'Authorization':
                                                            'Bearer $token'
                                                      }));
                                                  if (response.data['status'] ==
                                                      'CREATED') {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Registro completado exitosamente.')),
                                                    );
                                                    Navigator.of(context)
                                                        .popAndPushNamed(
                                                            '/manager');
                                                    // Navigator.pop(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           const RoomManagement()),
                                                    // );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'No se pudo realizar la petición, verifique sus datos')),
                                                    );
                                                  }
                                                } on DioException catch (e) {
                                                  print(e);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Ha sucedido un error al intentar registrar la habitación. Por favor intente mas tarde",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Algo salió mal al hacer la petición. Intente más tarde.')),
                                                  );
                                                  throw Exception(e);
                                                }
                                                // if (_formKeyRoomRegister.currentState!
                                                //     .validate()) {
                                                //   String identificador = _identificador.text;
                                                //   String numInit = _cantidadInicial.text;
                                                //   String numHab = _cantidad.text;
                                                //   try {
                                                //     final dio = Dio();
                                                //     Response response;
                                                //     response = await dio.post(
                                                //         '$path/saveRoom?nameInit=$identificador&numInit=$numInit&numHab=$numHab',
                                                //         data: {
                                                //           "identifier": identificador,
                                                //           'description': _descripcion.text,
                                                //           "status": 1,
                                                //         });
                                                //     if (response.data['msg'] == 'Register') {
                                                //       ScaffoldMessenger.of(context)
                                                //           .showSnackBar(
                                                //         const SnackBar(
                                                //             content: Text(
                                                //                 'Registro completado exitosamente.')),
                                                //       );
                                                //       Navigator.of(context).popAndPushNamed(
                                                //           '/manager/check_rooms');
                                                //     } else {
                                                //       ScaffoldMessenger.of(context)
                                                //           .showSnackBar(
                                                //         const SnackBar(
                                                //             content: Text(
                                                //                 'No se pudo realizar la petición, verifique sus datos')),
                                                //       );
                                                //     }
                                                //   } catch (e) {
                                                //     ScaffoldMessenger.of(context)
                                                //         .showSnackBar(
                                                //       const SnackBar(
                                                //           content: Text(
                                                //               'No se pudo realizar la petición, verifique sus datos')),
                                                //     );
                                                //   }
                                                // }
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
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
