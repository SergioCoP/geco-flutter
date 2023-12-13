import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  final String legend;

  const Splash({Key? key, required this.legend}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/personal_cleaner'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 100,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/geco_logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(widget.legend),
          ],
        ),
      ),
    );
  }
}
