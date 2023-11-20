import 'package:geco_mobile/modules/user/entities/user.dart';

class Incidence {
  int idIncidence;
  DateTime createdAt;
  String description;
  String image;
  int status;
  User user;

  Incidence(this.idIncidence,this.createdAt,this.description,this.image,this.status,this.user);
}