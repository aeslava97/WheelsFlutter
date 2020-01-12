import 'package:cloud_firestore/cloud_firestore.dart';
import 'car.dart';
import 'position.dart';

class Profile {
  Profile(
      {this.id,
      this.nombre,
      this.correo,
      this.telefono,
      this.sexo,
      this.fechaNacimiento,
      this.universidad,
      this.localidad,
      this.direccion,
      this.carros,
      this.casa,
      this.uni,
      this.referencia,
      this.token,
      this.tieneWheels = false});
  //datos que deberian llegar
  String nombre;
  String correo;
  int telefono;
  String id;
  String sexo;
  Timestamp fechaNacimiento;
  String universidad;
  String localidad;
  String direccion;
  List<Car> carros;
  DocumentReference referencia;
  //Esto toca calcularlo al crearse un perfil, pero ya deberia venir con el dato al traerse de firebase
  double latitud;
  double longitud;
  String token;

  //cosas que toca calcular con lo de arriba
  Position casa;
  Position uni;
  bool tieneWheels;

  Profile.cargarJson(DocumentSnapshot json)
      : id = json.documentID,
        nombre = json['nombre'],
        correo = json['correo'],
        telefono = json['telefono'],
        sexo = json['sexo'],
        fechaNacimiento = json['fecha_nacimiento'],
        universidad = json['universidad'],
        localidad = json['localidad'],
        direccion = json['direccion'],
        latitud = json['latitud'],
        longitud = json['longitud'],
        token = json['token'],
        carros = (json['carros'] == null)
            ? json['carros']
            : List<Car>.from(json['carros'].map((x) => Car.cargarJson(x)));

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'sexo': sexo,
      'localidad': localidad,
      'direccion': direccion,
      'latitud': latitud,
      'longitud': longitud,
      'universidad': universidad,
      'fecha_nacimiento': fechaNacimiento,
      'token': token
    };
  }

  void setCasa(Position pos) {
    casa = pos;
  }

  void setUni(Position un) {
    uni = un;
  }

  void setReferencia(DocumentReference reference) {
    referencia = reference;
  }

  void setTieneWheels(bool pTieneWheels) {
    tieneWheels = pTieneWheels;
  }

  
}
