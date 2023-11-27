import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
        centerTitle: true,
        backgroundColor: ColorsApp.primaryColor,
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Imagen de perfil redonda
                  const CircleAvatar(
                    radius:
                        100, // Ajusta el valor del radius según tu preferencia
                    backgroundImage: AssetImage(
                        'assets/profile_image.jpg'), // Cambia la imagen según tus necesidades
                  ),
                  SizedBox(height: 15,),

                  // Nombre completo en mayúsculas y negritas
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'RUBEN BARUC SALGADO ARMIJO',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Rol (por ejemplo, "Personal de limpieza")
                  const Text(
                    'Personal de limpieza',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  // Datos adicionales (correo y contraseña)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Correo Electrónico:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'usuario@example.com',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Contraseña:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '********',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  // Botón de Cerrar Sesión
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
