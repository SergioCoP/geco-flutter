class Incidence {
  int idIncidence;
  String discoveredOn;
  String description;
  String image;
  int status;
  int idUser;
  int idRoom;
  int idHotel;

  Incidence(this.idIncidence, this.discoveredOn, this.description, this.image,
      this.status, this.idUser, this.idRoom, this.idHotel);

  static Incidence fromJson(incidencia) {
    return Incidence(
      incidencia['idIncidence'],
      incidencia['discoveredOn'],
      incidencia['description'],
      incidencia['image'],
      incidencia['status'],
      incidencia['idUser']['idUser'],
      incidencia['idRoom']['idRoom'],
      incidencia['idRoom']['idHotel']['idHotel'],
    );
  }
}
