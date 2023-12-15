// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/kernel/toasts/toasts.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateIncidenceGerente extends StatefulWidget {
  final Room room;

  const CreateIncidenceGerente({Key? key, required this.room})
      : super(key: key);

  @override
  State<CreateIncidenceGerente> createState() => _CreateIncidenceState();
}

class _CreateIncidenceState extends State<CreateIncidenceGerente> {
  Color color1 = ColorsApp().primaryColor;
  Color color2 = ColorsApp().secondaryColor;
  bool hasIamge = false;
  final TextEditingController _incidenceDescriptionController =
      TextEditingController();
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

  File? _image;
  final _picker = ImagePicker();
  Future<void> _openImagePicker() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        hasIamge = true;
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        hasIamge = true;
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(
    File image,
  ) async {
    print(image.path);
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idUser = prefs.getInt('idUser');
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      final payload = {
        "image": base64Image,
        "description": _incidenceDescriptionController.text,
        "status": 1,
        "idUser": {"idUser": idUser},
        "idRoom": {"idRoom": widget.room.idRoom}
      };

      final responseImage = await dio.post('${GlobalData.pathUri}/incidence',
          data: payload,
          options: Options(headers: {
            // "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          }));
      print(responseImage.data);
      if (responseImage.data['status'] == 'OK') {
        await dio.put('${GlobalData.pathRoomUri}/status/${widget.room.idRoom}',
            data: {'status': 4},
            options: Options(headers: {
              // "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token'
            }));
        Toasts.showSuccessToast('incidencia registrada con éxito');
        Navigator.of(context).popAndPushNamed('/manager');
      }
    } on DioException catch (e) {
      print('ERROR DE DIO: $e');
    } catch (e, f) {
      print('ERROR DE CATCH AL CREAR LA INCIDENCIA: $e     , $f');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Registrar incidencia'),
          backgroundColor: color1,
          foregroundColor: Colors.white),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
            child: Card(
              color: Colors.white,
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorsApp.estadoConIncidencias,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        widget.room.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Input Text grande para describir la incidencia
                    TextField(
                      controller: _incidenceDescriptionController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: 'Describe la incidencia',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'insertar una imagen desde: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // Botones para cámara y galería
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsApp.infoColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                            onPressed: _getFromCamera,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_outlined),
                                SizedBox(width: 5.0),
                                Text('Cámara')
                              ],
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsApp.infoColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                            onPressed: _openImagePicker,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.image_outlined),
                                SizedBox(width: 5.0),
                                Text('Galería')
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Container gris de 30x30
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 150,
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : const Text('Aqui se mostrará la imagen'),
                    ),
                    const SizedBox(height: 50),
                    // Botón para registrar incidencia
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsApp.buttonPrimaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      onPressed: () {
                        if (_incidenceDescriptionController.text.isEmpty ||
                            !hasIamge) {
                          Toasts.showWarningToast(
                              'Por favor, ingrese una descripción y una imagen');
                        } else {
                          _uploadImage(_image!);
                        }
                      },
                      child: const Text('Registrar incidencia'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
