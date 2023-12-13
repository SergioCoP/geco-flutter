import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateIncidence extends StatefulWidget {
  final Room room;

  CreateIncidence({Key? key, required this.room}) : super(key: key);

  @override
  State<CreateIncidence> createState() => _CreateIncidenceState();
}

class _CreateIncidenceState extends State<CreateIncidence> {
  final TextEditingController _incidenceDescriptionController =
      TextEditingController();

  File? _image;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    print(image.path);
    try {
      final dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print(token);
      // int? idUser = prefs.getInt('idUser');
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last
            // filename: 'incidence.jpg',
            )
      });
      print(formData.files.first.value);
      final responseImage = await dio.post('${GlobalData.pathUri}/image-upload',
          data: {'image': formData.files.first.value},
          options: Options(headers: {
            // "Accept": "application/json",
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $token'
          }));
      print(responseImage.data);
      if (responseImage.data['status'] == 'OK') {
        print(responseImage.data['imageUrl']);
      }
      // List<int> imageBytes = await _image!.readAsBytes();
      // String base64Image = base64Encode(imageBytes);
      // await _registerIncidence(bytes);
    } on DioException catch (e) {
      print('ERROR DE DIO: $e');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _registerIncidence(String base64Image) async {
    try {
      // Response response = await dio.post(
      //   GlobalData.pathIncidenceUri,
      //   data: {
      //     'image': base64Image,
      //     'description': _incidenceDescriptionController.text,
      //     'status': widget.room.status,
      //     'idUser': {'idUser': widget.room.users.first.idUser},
      //     'idRoom': {'idRoom': idUser},
      //   },
      // );
      // if (response.data['status'] == 'CREATED') {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Incidencia registrada exitosamente.'),
      //     ),
      //   );
      //   Navigator.of(context)
      //       .pop(); // Cerrar la pantalla de incidencia después del registro exitoso
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content:
      //           Text('Error al registrar la incidencia. Inténtalo de nuevo.'),
      //     ),
      //   );
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Error al registrar la incidencia. Inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? statusColor;
    switch (widget.room.status) {
      case 0:
        statusColor = Colors.red;
        break;
      case 1:
        statusColor = ColorsApp.estadoEnVenta;
        break;
      case 2:
        statusColor = ColorsApp.estadoEnUso;
        break;
      case 3:
        statusColor = ColorsApp.estadoSucio;
        break;
      case 4:
        statusColor = ColorsApp.estadoSinRevisar;
        break;
      case 5:
        statusColor = ColorsApp.estadoConIncidencias;
        break;
      default:
        statusColor = Colors.grey;
        break;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Revisar incidencia'),
          backgroundColor: ColorsApp().primaryColor,
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
                        color: statusColor,
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
                      maxLines: 5,
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
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white),
                          onPressed: _getFromCamera,
                          child: const Text('Cámara'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white),
                          onPressed: _openImagePicker,
                          child: const Text('Galería'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Container gris de 30x30
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey[300],
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : const Text('Selecciona una imagen'),
                    ),
                    const SizedBox(height: 20),
                    // Botón para registrar incidencia
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsApp.buttonPrimaryColor,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        _uploadImage(_image!);
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
