import 'dart:io';

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
  TextEditingController _incidenceDescriptionController = TextEditingController();

  File? _image;

  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisar incidencia'),
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 32
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.room.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Input Text grande para describir la incidencia
            TextField(
              controller: _incidenceDescriptionController,
              maxLines: 5,
              decoration: InputDecoration(
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
                  onPressed: _getFromCamera,
                  child: Text('Cámara'),
                ),
                ElevatedButton(
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
                    : const Text('Please select an image'),
              ),
            SizedBox(height: 20),
            // Botón para registrar incidencia
            ElevatedButton(
              onPressed: () {
                // Lógica para registrar la incidencia
              },
              child: Text('Registrar incidencia'),
            ),
          ],
        ),
      ),
    );
  }
}
