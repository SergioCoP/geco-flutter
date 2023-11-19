import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/toasts/toasts.dart';

class RegisterHotel extends StatefulWidget {
  const RegisterHotel({super.key});

  @override
  State<RegisterHotel> createState() => _RegisterHotelState();
}

class _RegisterHotelState extends State<RegisterHotel> {
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
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: const ColoredBox(
                                          color: ColorsApp.primaryColor,
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: const ColoredBox(
                                          color: ColorsApp.secondaryColor,
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: const ColoredBox(
                                          color: ColorsApp.thirColor,
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                      )
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
                                                  ColorsApp.secondaryColor),
                                          onPressed: _isButtonDisabled
                                              ? null
                                              : () async {
                                                  Response response;
                                                  try {
                                                    response = await dio.request(
                                                        'http://192.168.0.163:8080/user/registerUser',
                                                        data: {
                                                          'email': arguments[
                                                                  'correoUs'] ??
                                                              '',
                                                          'password': arguments[
                                                                  'contrasenaUs'] ??
                                                              '',
                                                          'idPerson': {
                                                            'name': arguments[
                                                                    'nombreUs'] ??
                                                                '',
                                                            'surname': arguments[
                                                                    'apellidoPa'] ??
                                                                '',
                                                            'lastname': arguments[
                                                                    'apellidoMa'] ??
                                                                '',
                                                          },
                                                          "idRol": {"idRol": 1}
                                                        },
                                                        options: Options(
                                                            method: 'POST'));
                                                    print(response.data);
                                                    if (response.data['msg'] ==
                                                        'Register') {
                                                      response = await dio.request(
                                                          'http://192.168.0.163:8080/hotel/saveHotel',
                                                          data: {
                                                            'name': _nombreHotel
                                                                .text
                                                          },
                                                          queryParameters: {
                                                            "emailUser": arguments[
                                                                    'correoUs'] ??
                                                                ''
                                                          },
                                                          options: Options(
                                                              method: 'POST'));
                                                      if (response
                                                              .data['msg'] ==
                                                          'Register') {
                                                        Toasts.showSuccessToast(
                                                            'Registrado');
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                '/login');
                                                      } else {
                                                        Toasts.showWarningToast(
                                                            'Error al guardar el hotel');
                                                      }
                                                    } else {
                                                      Toasts.showWarningToast(
                                                          'Error al guardar el usuario');
                                                    }
                                                  } catch (e) {
                                                    print(e);
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
}
