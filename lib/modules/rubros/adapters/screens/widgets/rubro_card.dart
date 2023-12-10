// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/global/global_data.dart';
import 'package:geco_mobile/modules/rubros/entities/rubro.dart';

// ignore: must_be_immutable
class RubroCard extends StatefulWidget {
  Rubro rubro;

  RubroCard({super.key, required this.rubro});

  @override
  State<RubroCard> createState() => _RubroCardState();
}

class _RubroCardState extends State<RubroCard> {
  bool switchStatus = false;

  @override
  Widget build(BuildContext context) {
    switchStatus = widget.rubro.status == 1 ? true : false;
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 2.0,
      color: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: Colors.black, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(
            children: [
              SizedBox(
                width: 200.0,
                height: 50.0,
                child: Text(
                  widget.rubro.name,
                  maxLines: 3,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Switch(
                value: switchStatus,
                onChanged: (bool value) async {
                  final dio = Dio();
                  final path =
                      '${GlobalData.pathRubroUri}/status/${widget.rubro.idEvaluationItem}';
                  Response response;
                  response = await dio.put(path);
                  if (response.data['status'] == 'UPDATED') {
                    setState(() {
                      widget.rubro.status = switchStatus ? 1 : 0;
                      switchStatus = value;
                    });
                  }
                  setState(() {
                    switchStatus = value;
                    widget.rubro.status = switchStatus ? 1 : 0;
                  });
                },
                activeColor: Colors.green,
                inactiveTrackColor: Colors.red,
                inactiveThumbColor: Colors.red.shade100,
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Ink(
                ///Editar el rubro
                decoration: ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/manager/rubros/update',
                      arguments: {'idRubro': widget.rubro.idEvaluationItem},
                    );
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Ink(
                decoration: ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Rubro'),
                            content: SizedBox(
                                height: 50.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Rubro: ',
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: widget.rubro.name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Estado: ',
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: widget.rubro.status == 1
                                                ? 'Activo'
                                                : 'No activo',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cerrar'),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                  color: Colors.white,
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
