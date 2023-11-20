import 'package:geco_mobile/modules/user/entities/person.dart';

class User {
  int idUser;
  int status;
  String email;
  String password;
  Person person;

  User(this.idUser,this.status,this.email,this.password,this.person); 
}