import 'package:geco_mobile/modules/user/entities/Role.dart';
import 'package:geco_mobile/modules/user/entities/hotel.dart';

class User {
  int idUser;
  int status;
  String userName;
  String? lastname;
  String? surname;
  String? name;
  String email;
  String password;
  String turn;
  Rol idRol; // Cambiado a un objeto Rol
  Hotel idHotel; // Cambiado a un objeto Hotel

  User(this.idUser, this.status, this.userName, this.email, this.password, this.turn, this.idRol, this.idHotel);
}