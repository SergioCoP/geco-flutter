import 'package:flutter/material.dart';
import 'package:geco_mobile/kernel/theme/color_app.dart';
import 'package:geco_mobile/modules/login/adapters/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
        centerTitle: true,
        backgroundColor: ColorsApp().primaryColor,
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
                    radius: 100,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(height: 15),

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
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Botón de Cerrar Sesión
                  ElevatedButton(
                    onPressed: () async {
                      // Código para cerrar la sesión y limpiar datos
                      await _clearSessionData();

                      // Navega a la pantalla de inicio de sesión
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
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

  Future<void> _clearSessionData() async {
    // Aquí puedes realizar la limpieza de datos de sesión, por ejemplo, eliminar el token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // Esto eliminará todos los datos almacenados en SharedPreferences
    // También puedes eliminar datos específicos, por ejemplo:
    // prefs.remove('token');
  }
}
