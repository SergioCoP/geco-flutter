// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/rubros/entities/rubro.dart';

class RubroRegister extends StatefulWidget {
  const RubroRegister({super.key});

  @override
  State<RubroRegister> createState() => _RubroRegisterState();
}

class _RubroRegisterState extends State<RubroRegister> {
  final TextStyle textStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

  late Rubro rubro;

  final _path = GlobalData.pathRubroUri;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController(text: '');
  bool _isButtonDisabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Rubro"),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
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
                      Text(
                        'Identificador',
                        style: textStyle,
                      ),
                      TextFormField(
                        controller: _description,
                        decoration: const InputDecoration(
                          labelText: "Descripcion del rubro",
                          hintText: "Descripcion del rubro",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La descripcion del rubro es requerida";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          rubro.name = value!;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            onPressed: _isButtonDisabled
                                ? null
                                : () async {
                                    final data = {
                                      'name': _description.text,
                                      'idHotel': {'idHotel': 1}
                                    };
                                    try {
                                      final dio = Dio();
                                      Response response;
                                      response =
                                          await dio.post(_path, data: data);
                                      if (response.data['status'] == 'CREATED') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Rubro registrado correctamente.'),
                                        ));
                                        Navigator.of(context)
                                            .popAndPushNamed('/manager/rubros');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Error al registrar rubro. Verifique sus datos.'),
                                        ));
                                      }
                                    } catch (e) {
                                      print(e);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Error al registrar rubro. Verifique sus datos.'),
                                      ));
                                    }
                                  },
                            child: const Text("Registrar rubro")),
                      )
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
