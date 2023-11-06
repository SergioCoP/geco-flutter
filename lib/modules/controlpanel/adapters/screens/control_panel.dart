import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class ControlPanel extends StatelessWidget{
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: ColorsApp.primaryColor),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(1),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {  },
                     icon: const Icon(Icons.menu),
                     tooltip: 'Menu',
                  ),
                  const Expanded(
                    child: Text('Panel de control',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20 ),),
                  )
                ],
              ),
            ),
             Container(
              margin: const EdgeInsets.all(2),
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.all(20),
                shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 130),
                            child: const Column(children: [
                               Text('Total de cuartos',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            Text('30',style: TextStyle(fontSize: 16),)
                            ]),
                          ),
                          Card(
                            elevation: 3,
                            color: ColorsApp.thirColor,
                            shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child:  Container(
                              margin: const EdgeInsets.only(right: 40,top: 10,left: 10,bottom: 10),
                                child:  Row(
                                    children: [
                                       Container(
                                        margin: const EdgeInsets.only(right: 30,top: 5,bottom: 5),
                                        child: const Text('En renta',style: TextStyle(fontWeight: FontWeight.bold),)) ,
                                       Container(
                                        margin: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                        child: const Text('20'))
                                    ],  
                                ),
                              ),
                          )
                        ],
                      ),
                      
                    )
                  ]),
              ),
            )
          ],
        ),
    );
  }

}