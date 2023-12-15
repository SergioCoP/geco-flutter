// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TypeRoomRegister extends StatefulWidget {
  const TypeRoomRegister({super.key});

  @override
  State<TypeRoomRegister> createState() => _TypeRoomRegisterState();
}

class _TypeRoomRegisterState extends State<TypeRoomRegister> {
  final _path = GlobalData.pathTypeRoomUri;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController(text: '');
  bool _isButtonDisabled = true;

  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;

  @override
  void initState() {
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar un tipo de habitación'),
        backgroundColor: color1,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    _isButtonDisabled = !_formKey.currentState!.validate();
                  });
                },
                child: Card(
                  elevation: 4.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5.0), // Ajusta el radio del borde de la tarjeta
                    side: const BorderSide(
                        color: Colors.black,
                        width: 0.5), // Añade un borde más marcado
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Nombre del tipo de cuarto'),
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            hintText: 'Nombre del tipo de habitación',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'El nombre es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                            onPressed: _isButtonDisabled
                                ? null
                                : () async {
                                    final dio = Dio();
                                    try {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? token = prefs.getString('token');
                                      int? idHotel = prefs.getInt('idHotel');
                                      final response = await dio.post(_path,
                                          data: {
                                            'name': _name.text,
                                            'idHotel': {'idHotel': idHotel}
                                          },
                                          options: Options(headers: {
                                            // "Accept": "application/json",
                                            // "Content-Type": "application/json",
                                            'Authorization': 'Bearer $token'
                                          }));
                                      if (response.data['status'] ==
                                          'CREATED') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Tipo de cuarto registrado correctamente.'),
                                        ));
                                        // Navigator.popAndPushNamed(
                                        //     context, '/manager/types');
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           const TypeRoomManagement()),
                                        // );
                                        Navigator.of(context)
                                            .popAndPushNamed('/manager');
                                      }
                                    } on DioException catch (e) {
                                      print(e);
                                      Fluttertoast.showToast(
                                          msg:
                                              "Ha sucedido un error al intentar registrar el tipo de habitación. Por favor intente mas tarde",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Error al registrar rubro. Verifique sus datos.'),
                                      ));
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsApp.buttonPrimaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                            child: const Text('Registrar'))
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
