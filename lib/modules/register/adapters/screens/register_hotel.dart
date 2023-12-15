// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterHotel extends StatefulWidget {
  const RegisterHotel({Key? key}) : super(key: key);

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
          _buildHeader(),
          Expanded(
            child: _buildForm(arguments),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      height: 150,
      color: ColorsApp().primaryColor,
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
    );
  }

  Widget _buildForm(arguments) {
    return Container(
      alignment: Alignment.center,
      color: ColorsApp().primaryColor,
      child: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(15),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                _isButtonDisabled = !_formKey.currentState!.validate();
              });
            },
            child: Column(
              children: [
                _buildFormTitle(),
                _buildHotelNameField(),
                _buildColorPalette(),
                _buildRegisterButton(arguments),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormTitle() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Column(
        children: [
          Text(
            'Registro de hotel',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelNameField() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Nombre del hotel',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            keyboardType: TextInputType.text,
            controller: _nombreHotel,
            validator: (val) {
              if (val!.isEmpty) {
                return 'Campo obligatorio';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorPalette() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Selecciona los colores para tu hotel',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildColorPicker(
                  primaryColor, (color) => _onColorChanged(color, 1)),
              _buildColorPicker(
                  secondaryColor, (color) => _onColorChanged(color, 2)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildColorPicker(Color color, Function(Color) onColorChanged) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ColorBox(color: color, onColorChanged: onColorChanged),
    );
  }

  Widget _buildRegisterButton(arguments) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                minimumSize: const Size(400, 60),
                backgroundColor: ColorsApp().secondaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _isButtonDisabled
                  ? null
                  : () async {
                      await _registerHotel(arguments);
                    },
              child: const Text('Registrar'),
            ),
          )
        ],
      ),
    );
  }

  void _onColorChanged(Color color, int boxNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un color'),
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
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerHotel(arguments) async {
    // ... Lógica de registro del hotel
    Response response;
    String color1 = primaryColor.toString();
    color1 = color1.substring(6, color1.length - 1);
    String color2 = secondaryColor.toString();
    color2 = color2.substring(6, color2.length - 1);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final dataHotel = {
        "email": arguments['correoUs'] ?? '',
        "password": arguments['contrasenaUs'] ?? '',
        'username': arguments['username'] ?? '',
        "idPerson": {
          "name": arguments['nombreUs'] ?? '',
          "surname": arguments['apellidoPa'] ?? '',
          "lastname": arguments['apellidoMa'] ?? '',
        },
        'idHotel': {
          "name": _nombreHotel.text,
          "imageUrl":
              "https://i.pinimg.com/736x/5e/86/a8/5e86a8faa7260d858eb3b1b9fa4236bf.jpg",
          "primaryColor": color1,
          "secondaryColor": color2
        }
      };
      response =
          await dio.post('${GlobalData.pathUserUri}/hotel', data: dataHotel);
      if (response.data['status'] == 'CREATED') {
        final response2 = await dio.post('${GlobalData.pathUserUri}/login',
            data: {
              'user': arguments['username'] ?? '',
              'password': arguments['contrasenaUs'] ?? ''
            });
        if (response2.data['status'] == 'OK') {
          prefs.setString('token', response2.data['token']);
          prefs.setInt('idUser', response2.data['user']['idUser']);
          prefs.setInt('idHotel', response2.data['user']['idHotel']['idHotel']);
          prefs.setString('primaryColor', color1);
          prefs.setString('secondaryColor', color2);
          Navigator.pushReplacementNamed(context, '/manager');
        } else {
          //Usuario no activo
          Navigator.popUntil(context, ModalRoute.withName('/login'));
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        final responseCode = e.response!.statusCode;
        if (responseCode != 200) {
          final errorMessage = responseData['message'] ?? 'Error desconocido';
          if (errorMessage.contains('No se creó el registro')) {
            // Manejar el caso de correo duplicado
            Fluttertoast.showToast(
              msg: 'El correo electrónico ya está registrado.',
              // ... Otros parámetros del toast
            );
          } else if (errorMessage.contains('No se pudo registrar a el hotel')) {
            // Manejar el caso de hotel duplicado
            Fluttertoast.showToast(
              msg: 'El hotel ya está registrado.',
              // ... Otros parámetros del toast
            );
          } else {
            // Otro tipo de error
            Fluttertoast.showToast(
              msg: 'Error: $errorMessage',
              // ... Otros parámetros del toast
            );
          }
        }
      } else {
        // Error de conexión, timeout, etc.
        Fluttertoast.showToast(
          msg: 'Error de conexión. Por favor, verifica tu conexión a internet.',
          // ... Otros parámetros del toast
        );
      }
    } catch (e, f) {
      print('ERROR:  $e,  ERRROR CON DETALLES:   $f');
      Fluttertoast.showToast(
          msg:
              "Ha sucedido un error al intentar registra el hotel Verifique sus datos y pruebe mas tarde.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

class ColorBox extends StatelessWidget {
  final Color color;
  final Function(Color) onColorChanged;

  const ColorBox({Key? key, required this.color, required this.onColorChanged})
      : super(key: key);

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
