
import 'package:cloud_firestore/cloud_firestore.dart';

class Position {
  const Position({ this.lat, this.lng});
  final double lat;
  final double lng;

  @override
  String toString() {
    return '$lat-$lng';
  }

  Position.cargarJson(DocumentSnapshot json) : 
  lat=json['latitud'],
  lng=json['longitud'];
}