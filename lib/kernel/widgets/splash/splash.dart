import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  final String legend; //definir propiedades del constructor
  const Splash({super.key, required this.legend}); 
  @override
  State<Splash> createState() => _SplashState();//_refiere a que la clase es privada
}

class _SplashState extends State<Splash> {
  @override
  void initState(){//se ejecuta despues de cargar el componente o widget
    super.initState();
    Future.delayed(const Duration(seconds: 2),() => Navigator.pushReplacementNamed(context, '/login'));
  }
 //requires para hacer obligatorio
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,//centrar contenido
        children: <Widget>[
            ClipOval(
              child: Image.asset(
                'assets/images/geco_logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover, // Ajusta la imagen al círculo
              ),
            ),
            const SizedBox(height: 20), // Espacio entre la imagen y el texto
            Text(widget.legend),
          ],),),
    );
  }
}