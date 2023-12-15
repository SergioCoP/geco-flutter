import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  final String legend; // Definir propiedades del constructor
  const Splash({Key? key, required this.legend}) : super(key: key);

  @override
  State<Splash> createState() =>
      _SplashState(); // _refiere a que la clase es privada
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _loadSplash();
  }

  Future<void> _loadSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                'assets/images/geco_logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            // const SizedBox(height: 20),
            // Text(widget.legend),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.green), // Indicador de carga
          ],
        ),
      ),
    );
  }
}
