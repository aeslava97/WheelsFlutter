import 'package:cloud_firestore/cloud_firestore.dart';


class Passenger {
  Passenger({this.perfil, this.latitud, this.longitud});
  DocumentReference perfil;
  double latitud;
  double longitud;

  Passenger.cargarJson(Map<dynamic,dynamic> json)
      : perfil = json['idPasajero'],
        latitud = json['latitud'],
        longitud = json['longitud'];

}
