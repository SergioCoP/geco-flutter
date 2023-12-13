import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/gerente/room/entities/room.dart';
import 'package:image_picker/image_picker.dart';


class CreateIncidence extends StatefulWidget {
  final Room room;

  CreateIncidence({Key? key, required this.room}) : super(key: key);

  @override
  State<CreateIncidence> createState() => _CreateIncidenceState();
}

class _CreateIncidenceState extends State<CreateIncidence> {
  TextEditingController _incidenceDescriptionController =
      TextEditingController();

  File? _image;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
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

  Future<void> _uploadImage() async {
    if (_image != null) {
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      await _registerIncidence(base64Image);
    }else{
      print('no hay img');
    }
  }

  Future<void> _registerIncidence(String base64Image) async {
    try {
      final dio = Dio();
      Response response = await dio.post(
        'http://192.168.0.3:8080/api/incidence',
        data: {
          'image': base64Image,
          'description': _incidenceDescriptionController.text,
          'status': widget.room.status,
          'idUser': {'idUser': widget.room.users.first.idUser},
          'idRoom': {'idRoom': widget.room.idRoom},
        },
      );

      if (response.data['status'] == 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incidencia registrada exitosamente.'),
          ),
        );
        Navigator.of(context)
            .pop(); // Cerrar la pantalla de incidencia después del registro exitoso
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error al registrar la incidencia. Inténtalo de nuevo.'),
          ),
        );
      }
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
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    widget.room.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                // Input Text grande para describir la incidencia
                TextField(
                  controller: _incidenceDescriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Descripción de la incidencia',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Botones para cámara y galería
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: _getFromCamera,
                      child: Text('Cámara'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: _openImagePicker,
                      child: Text('Galería'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                // Botón para registrar incidencia
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.thirColor,
                  ),
                  onPressed: (){
                    print('REGISTRARRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
                    _uploadImage();
                  },
                  child: Text('Registrar incidencia'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
