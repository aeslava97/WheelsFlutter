import 'package:cloud_firestore/cloud_firestore.dart';
import 'passenger.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'descripcion.dart';

enum WheelsDirecion { casa_Uni, uni_casa }

class Wheels {

  Wheels(
      {
      this.idWheels,
      this.profile,
      this.localidad,
      this.fechaCreacion,
      this.fechaPartida,
      this.cupos,
      this.fechaCuposCompletados,
      this.sentido,
      this.descripcion,
      this.listaPasajeros,
      this.hora,
      this.direction,
      this.referencia,
      this.seleccionado=false,
      this.creado=false,
      this.estado
      });

  //Lo que le entra por firebase
  String idWheels;
  Profile profile;
  String localidad;
  Timestamp fechaCreacion;
  Timestamp fechaPartida;
  int cupos;
  Timestamp fechaCuposCompletados;
  String sentido;
  Descripcion descripcion;
  List<Passenger> listaPasajeros;
  String referencia;
  bool seleccionado;
  bool creado;
  String estado;


  //las cosas que tengo que calcular con los datos de arriba
  TimeOfDay hora;
  WheelsDirecion direction;

  Wheels.cargarJson(DocumentSnapshot json)
      : idWheels = json.documentID,
        localidad = json['localidad'],
        fechaCreacion = json['fecha_creacion'],
        fechaPartida = json['fecha_partida'],
        cupos = json['cupos'],
        fechaCuposCompletados = json['fecha_cupos_completados'],
        seleccionado = false,
        creado = false,
        sentido = json['sentido'],
        estado = json['estado'],
        descripcion = Descripcion.cargarJson(json['descripcion']),
        listaPasajeros=(json['pasajeros'] == null) ? json['pasajeros']  : List<Passenger>.from(json['pasajeros'].map((x) => Passenger.cargarJson(x)))
;
  void setDirection(WheelsDirecion dir) {
    direction = dir;
  }

  void setHora(TimeOfDay hor) {
    hora = hor;
  }
  void setReferencia(String reference){
    referencia=reference;
  }
  void setSeleccionado(bool pSeleccionado){
    seleccionado=pSeleccionado;
  }
  void setCreado(bool pCreado){
    creado=pCreado;
  }
  bool getSeleccionado(){
    return seleccionado;
  }
}
