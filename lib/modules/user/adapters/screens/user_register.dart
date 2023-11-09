import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  final bool _isButtonDisabled = true;

  final TextEditingController _nombresController = TextEditingController(text: '');
  final TextEditingController _apellidoPaternoController =
      TextEditingController(text: '');
  final TextEditingController _apellidoMaternoController =
      TextEditingController(text: '');
  final TextEditingController _contraseniaController = TextEditingController(text: '');
  final TextEditingController _contraseniaConfirmController =
      TextEditingController(text: '');
  final TextEditingController _correoController = TextEditingController(text: '');
  String? _rolSeleccionado;

  @override
  void initState() {
    super.initState();
    _rolSeleccionado = 'Recepcionista'; // Valor predeterminado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Padding(
          padding: EdgeInsets.all(6),
          child: Center(
            child: Card(
              child: Container(
                width: 350,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  key: _formKey,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nombresController,
                      decoration: InputDecoration(
                        labelText: 'Nombres',
                      ),
                    ),
                    TextField(
                      controller: _apellidoPaternoController,
                      decoration: InputDecoration(labelText: 'Apellido Paterno'),
                    ),
                    TextField(
                      controller: _apellidoMaternoController,
                      decoration: InputDecoration(labelText: 'Apellido Materno'),
                    ),
                    TextField(
                      controller: _correoController,
                      decoration: InputDecoration(labelText: 'Correo'),
                    ),
                    TextField(
                      controller: _contraseniaController,
                      decoration: InputDecoration(labelText: 'Contraseña'),
                    ),
                    TextField(
                      controller: _contraseniaConfirmController,
                      decoration:
                          InputDecoration(labelText: 'Confirmar contraseña'),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Tipo de usuario'),
                      value: _rolSeleccionado,
                      items: ['Recepcionista', 'Personal de Limpieza']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _rolSeleccionado = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF589F56),
                        ),
                        child: Text('Registrarse'),
                        onPressed: _isButtonDisabled? null : () async {
                          // const path = 'http://192.168.0.6:8080';
                          // final dio = Dio();
                          // final response = await dio.post('$path/registerUser', data: {
                          //   'nombres': _nombresController.text,
                          //   'apellido_paterno': _apellidoPaternoController.text,
                          //   'apellido_materno': _apellidoMaternoController.text,
                          //   'correo': _correoController.text,
                          //   'contrasenia': _contraseniaController.text,
                          //   'rol': _rolSeleccionado,
                          // });
                          // if (response.statusCode == 200) {
                          //   // Mostrar un toast de registro exitoso
                          //   Fluttertoast.showToast(
                          //     msg: 'Registro exitoso',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.CENTER,
                          //     backgroundColor: Color(0xFF589F56),
                          //     textColor: Colors.white,
                          //     fontSize: 16.0,
                          //   );
                          // } else {
                          //   Fluttertoast.showToast(
                          //     msg: 'Error en el registro',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.CENTER,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0,
                          //   );
                          // }
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
