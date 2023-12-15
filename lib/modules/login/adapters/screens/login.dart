// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/toasts/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    isSessionActive();
  }

  Future<void> isSessionActive() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? session = prefs.getBool('session');
      int? idRol = prefs.getInt('idRol');

      if (session != null && session) {
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
    } on DioException catch (e) {
      print(e);
      showErrorMessage();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  void showErrorMessage() {
    Fluttertoast.showToast(
      msg:
          "Ha sucedido un error al iniciar sesión. Verifique usuario y contraseña.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorsApp = ColorsApp();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
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
                    child: Image.asset('assets/images/geco_logo.png'),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatefulWidget {
  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonDisabled = true;
  bool passVisible = true;
  final TextEditingController _email = TextEditingController(text: '');
  final TextEditingController _password = TextEditingController(text: '');

  Future<void> login() async {
    // var colorsApp = ColorsApp();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      final response = await dio.post('${GlobalData.pathUserUri}/login',
          data: {"user": _email.text, "password": _password.text});

      if (response.statusCode == 404 || response.data['status'] != 'OK') {
        Toasts.showWarningToast('Contraseña o correo incorrectos');
      } else {
        handleSuccessfulLogin(response, prefs);
      }
    } on DioException catch (e) {
      print(e.response?.statusCode);
      if (e.response?.statusCode == 404) {}
      showErrorMessage();
    } catch (e, stackTrace) {
      print('ERROR: $e');
      print('StackTrace: $stackTrace');
      throw Exception(e);
    }
  }

  void handleSuccessfulLogin(Response response, SharedPreferences prefs) {
    print('Entre a handlerSuccessFull');
    if (response.data['user']['status'] == 1) {
      // Usuario activo
      String color1 = response.data['user']['idHotel']['primaryColor']
          .replaceAll('#', '0xff');
      String color2 = response.data['user']['idHotel']['secondaryColor']
          .replaceAll('#', '0xff');
      prefs.setString('primaryColor', color1);
      prefs.setString('secondaryColor', color2);
      // colorsApp.setPrimaryColor(Color(int.parse(color1)));
      // colorsApp.setSecondaryColor(Color(int.parse(color2)));
      prefs.setInt('idHotel', response.data['user']['idHotel']['idHotel']);
      prefs.setString('namehotel', response.data['user']['idHotel']['name']);
      prefs.setInt('idRol', response.data['user']['idRol']['idRol']);

      switch (response.data['user']['idRol']['idRol']) {
        case 1:
          prefs.setBool('session', true);
          prefs.setString('token', response.data['token']);
          prefs.setInt('idUser', response.data['user']['idUser']);
          Navigator.pushReplacementNamed(context, '/manager');
          break;
        case 3:
          prefs.setBool('session', true);
          prefs.setString('token', response.data['token']);
          prefs.setInt('idUser', response.data['user']['idUser']);
          Navigator.pushReplacementNamed(context, '/personal_cleaner');
          break;
        default:
          prefs.clear();
          break;
      }
    } else {
      prefs.clear();
      // Usuario no activo
      Toasts.showWarningToast('Usuario no activo');
      Navigator.popUntil(context, ModalRoute.withName('/login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorsApp = ColorsApp();

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  onChanged: () {
                    setState(() {
                      _isButtonDisabled = !_formKey.currentState!.validate();
                    });
                  },
                  child: Column(
                    children: <Container>[
                      // ... (resto del código)
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
                                    fontSize: 22, fontWeight: FontWeight.bold),
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
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  minimumSize: const Size(400, 60),
                                  backgroundColor: colorsApp.secondaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _isButtonDisabled ? null : login,
                                child: const Text('Iniciar sesión'),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    "@ SCP S.A de C.V 2023",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showErrorMessage() {
  Fluttertoast.showToast(
    msg:
        "Ha sucedido un error al iniciar sesión. Verifique usuario y contraseña.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
