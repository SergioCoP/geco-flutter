class Person {
  int idPerson;
  String name;
  String? surname;
  String lastname;

  Person(this.idPerson, this.name, this.surname, this.lastname);

  static Person fromJson(idPerson) {
    return Person(idPerson['idPerson'] ?? 0, idPerson['name'], idPerson['surname'] ?? '',
        idPerson['lastname'] ?? '');
  }
}
