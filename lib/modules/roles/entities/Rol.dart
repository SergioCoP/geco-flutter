class Rol {
  int idRol;
  String name;
  String description;
  Rol(this.idRol, this.name, this.description);

  static Rol fromJson(idRol) {
    return Rol(
        idRol['idRol'] ?? 0, idRol['name'] ?? '', idRol['description'] ?? '');
  }

  static Rol? defaultRol() {
    return Rol(0, '', '');
  }
}
