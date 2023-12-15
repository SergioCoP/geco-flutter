// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/toasts/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<StatefulWidget> createState() => _Login2();
}

class _Login2 extends State<Login2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSessionActive();
  }

  Future isSessionActive() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? session = prefs.getBool('session');
      int? idRol = prefs.getInt('idRol');
      if (session != null) {
        if (session) {
          switch (idRol) {
            case 1:
              Navigator.pushReplacementNamed(context, '/manager');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/personal_cleaner');
              break;
            default:
              prefs.clear();
              break;
          }
        }
      }
    } on DioException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al iniciar sesión. Verifique que su usuario y contraseña sean los correctos.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorsApp = ColorsApp();
    //Image.asset('assets/images/geco_logo.png',width: 150,height: 150,),
    return Scaffold(
        body: Column(
      children: <Widget>[
        // ignore: avoid_unnecessary_containers
        Container(
          child: Container(
            alignment: Alignment.center,
            height: 150,
            color: colorsApp.primaryColor,
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
        ),
        Expanded(
          child: Container(
              alignment: Alignment.center,
              color: colorsApp.secondaryColor,
              child: Container(
                alignment: Alignment.center,
                child: _FormCard(),
              )),
        ),
      ],
    ));
  }
}

class _FormCard extends StatefulWidget {
  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field, prefer_final_fields
  bool _isButtonDisabled = true;
  bool passVisible = true;

  final TextEditingController _email = TextEditingController(text: '');

  final TextEditingController _password = TextEditingController(text: '');

  Future login() async {
    var colorsApp = ColorsApp();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      // dio.options.headers[
      //     'Authorization'] = 'Bearer ';
      final response = await dio.post('${GlobalData.pathUserUri}/login',
          data: {"user": _email.text, "password": _password.text});
      if (response.statusCode == 404) {
        Toasts.showWarningToast('Contraseña o correo incorrectos');
      }
      if (response.data['status'] == 'OK' &&
          response.data['message'] == 'Inicio de sesión exitoso') {
        ///login exitoso
        if (response.data['user']['status'] == 1) {
          //El usuario esta activo
          String color1 = response.data['user']['idHotel']['primaryColor']
              .replaceAll('#', '0xff');
          String color2 = response.data['user']['idHotel']['secondaryColor']
              .replaceAll('#', '0xff');
          prefs.setString('primaryColor', color1);
          prefs.setString('secondaryColor', color2);
          colorsApp.setPrimaryColor(Color(int.parse(color1)));
          colorsApp.setSecondaryColor(Color(int.parse(color2)));
          prefs.setInt('idHotel', response.data['user']['idHotel']['idHotel']);
          prefs.setInt('idRol', response.data['user']['idRol']['idRol']);
          switch (response.data['user']['idRol']['idRol']) {
            case 1: //Es gerente
              prefs.setBool('session', true);
              await prefs.setString('token', response.data['token']);
              await prefs.setInt('idUser', response.data['user']['idUser']);
              Navigator.pushReplacementNamed(context, '/manager');
              break;
            case 3: //Es limpieza
              prefs.setBool('session', true);
              await prefs.setString('token', response.data['token']);
              await prefs.setInt('idUser', response.data['user']['idUser']);
              Navigator.pushReplacementNamed(context, '/personal_cleaner');
              break;
            default: //No tiene derecho a la app
              prefs.clear();
              break;
          }
        } else {
          prefs.clear();
          //Usuario no activo
          Navigator.popUntil(context, ModalRoute.withName('/login'));
        }
      } else {
        Toasts.showWarningToast('Contraseña o correo incorrectos');
      }
    } on DioException catch (e) {
      print(e.response?.statusCode);
      if (e.response?.statusCode == 404) {}
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al iniciar sesión. Verifique que su usuario y contraseña sean los correctos.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } on HttpStatus catch (e) {
      print('HttpStatus: $e');
    } catch (e, stackTarce) {
      print('ERROS; $e');
      print('StackTrace: $stackTarce');
      throw Exception(e);
    } finally {
      // Código que se ejecutará independientemente de si se lanza una excepción o no
      print('Bloque Finally');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var colorsApp = ColorsApp();
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
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
                        children: 
                        <Container>[
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                    "Usuario  o correo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    validator: (val) {
                                      // RegExp regex =
                                      //     RegExp(ValidationsApp.email);
                                      // if (val!.isEmpty) {
                                      //   return 'Campo obligatorio';
                                      // } else if (!regex.hasMatch(val)) {
                                      //   return 'Correo invalido';
                                      // }
                                      if (val!.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                      return null;
                                    },
                                    // keyboardType: TextInputType.emailAddress,
                                    controller: _email,
                                  ),
                                )
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const Text(
                                  "Contraseña",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    obscureText: passVisible,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      suffixIcon: IconButton(
                                        icon: Icon(passVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            passVisible = !passVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: _password,
                                  ),
                                )
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        textStyle: const TextStyle(
                                            fontSize: 15, color: Colors.black)),
                                    onPressed: () {},
                                    child: const Text('Recuperar Contraseña'),
                                  ),
                                )
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                        minimumSize: const Size(400, 60),
                                        backgroundColor:
                                            colorsApp.secondaryColor,
                                        foregroundColor: Colors.white),
                                    onPressed: _isButtonDisabled
                                        ? null
                                        : () {
                                            login();
                                          },
                                    child: const Text('Iniciar'),
                                  ),
                                )
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/registerUser');
                                    },
                                    child: const Text(
                                        '¿No tienes una cuenta?, Registrate'),
                                  ),
                                )
                              ],
                            )),
                      ]))
                ],
              )),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "GECO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    "@ SCP S.A de C.V 2023",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
