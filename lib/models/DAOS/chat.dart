import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  Chat({this.idEmisor, this.fecha, this.text, this.nombre, this.idPerfil});
  DocumentReference idEmisor;
  Timestamp fecha;
  String text;
  String nombre;
  String idPerfil;
  Chat.cargarJson(DocumentSnapshot json)
      : idEmisor = json['idEmisor'],
        fecha = json['fecha'],
        text = json['text'],
        nombre = json['nombre'];

  Map<String, dynamic> toJson() {
    return {
      'idEmisor': idEmisor,
      'fecha': fecha,
      'text': text,
      'nombre': nombre
    };
  }
}
