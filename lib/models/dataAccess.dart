import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/DAOS/DAOS.dart';

//conexion firestore
final usuarios = Firestore.instance.collection("usuarios");
final viajes = Firestore.instance.collection("wheels");

const Position geoUniandes = Position(lat: 4.602866, lng: -74.065230);
const String dirUniandes = "Cra. 1 #18a 12";
var latitud;
var longitud;

//Este metodo hace el llamado a la API geoCoder
Future<Position> getPositionAddres(String addres) async {
  if (addres.isEmpty) return null;
  try {
    final resp = await Geocoder.local.findAddressesFromQuery(addres);
    latitud = resp?.first?.coordinates?.latitude;
    longitud = resp?.first?.coordinates?.longitude;

    if (latitud != null && longitud != null) {
      excepcion(false);
      return new Position(lat: latitud, lng: longitud);
    }
  } on PlatformException {
    excepcion(true);
    print('address not found');
  }
  return null;
}

//Este metodo hace el llamado a la API geoCodery sacar con una Position una direccion
Future<Address> getAddressPosition(double lat, lng) async {
  var first = Address(addressLine: "Bogotá");
  Coordinates latlng = Coordinates(lat, lng);
  try {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(latlng);
    first = addresses?.first;
  } on PlatformException {
    print('address not found');
  }
  return first;
}

//metodo para indicar excepcion a la hora de hacer render de los mapas
bool excepcion(parametro) {
  return parametro;
}

//metodo para verificar si el usuario tiene carros registrados
bool hasCars(Profile perfil) {
  if (perfil?.carros?.length > 0) {
    return true;
  }
  return false;
}

//crear carro
createCarro(Profile perfil, String color, String modelo, String placa) async {
  DocumentReference a = Firestore.instance
      .collection("usuarios")
      .document(perfil.referencia.documentID);
  await a.updateData({
    "carros": FieldValue.arrayUnion([
      {"color": color, "modelo": modelo, "placa": placa}
    ])
  });

  DocumentSnapshot b = await a.get();
  Profile.cargarJson(b);
}

cancerlarReserva(Wheels wheels, Profile perfil) {
  int cuposActuales = wheels.cupos;
  DocumentReference docRef =
      Firestore.instance.collection("wheels").document(wheels.referencia);

  for (int i = 0; i < wheels.listaPasajeros.length; i++) {
    if (wheels.listaPasajeros[i].perfil == perfil.referencia) {
      docRef.updateData({
        "pasajeros": FieldValue.arrayRemove([
          {
            "idPasajero": perfil.referencia,
            "latitud": perfil.latitud,
            "longitud": perfil.longitud
          }
        ])
      });
      docRef.updateData({"cupos": cuposActuales = cuposActuales + 1});
    }
  }
  perfil.setTieneWheels(false);
}

reservarWheels(Wheels wheels, Profile perfil) async {
  if (wheels.cupos > 0) {
    int cuposActuales = wheels.cupos;
    Firestore.instance
        .collection("wheels")
        .document(wheels.referencia)
        .updateData({"cupos": cuposActuales = cuposActuales - 1});

    DocumentReference a =
        Firestore.instance.collection("wheels").document(wheels.referencia);
    a.updateData({
      "pasajeros": FieldValue.arrayUnion([
        {
          "idPasajero": perfil.referencia,
          "latitud": perfil.latitud,
          "longitud": perfil.longitud
        }
      ])
    });
    perfil.setTieneWheels(true);
  }
}

//devuelve la lista de wheels
Future<List<Wheels>> getWheels(WheelsDirecion wheelsDirecion, Profile p) async {
  String direccion =
      (wheelsDirecion == WheelsDirecion.casa_Uni) ? "hacia" : "desde";
  //final varViajes = (wheelsDirecion == WheelsDirecion.uni_casa) ? viajes.where("localidad", isEqualTo: p.localidad) : viajes.where("sentido", isEqualTo: "hacia");
  QuerySnapshot b = await Firestore.instance
      .collection("wheels")
      .where("sentido", isEqualTo: direccion)
      .where("localidad", isEqualTo: p.localidad)
      .where("estado", isEqualTo: 'espera')
      .where("fecha_partida", isGreaterThan: Timestamp.now())
      .getDocuments();

  QuerySnapshot c = await Firestore.instance
      .collection("wheels")
      .where("sentido", isEqualTo: direccion)
      .where("localidad", isEqualTo: p.localidad)
      .where("estado", isEqualTo: 'transcurso')
      .where("fecha_partida", isGreaterThan: Timestamp.now())
      .getDocuments();

  b.documents.addAll(c.documents);

  p.setTieneWheels(false);
  Future<Profile> getProfile(String ref) async {
    DocumentSnapshot a = await Firestore.instance.document(ref).get();
    return Profile.cargarJson(a);
  }

  var listaDeWheels = b.documents.map((doc) => Wheels.cargarJson(doc)).toList();
  List<DocumentReference> profileRef = List<DocumentReference>.from(
      b.documents.map((doc) => doc["idConductor"]).toList());

  List<DocumentSnapshot> referencias = b.documents.toList();

  //verficar si el perfil hace parte
  bool encontrado = false;
  Profile pasajero;

  listaDeWheels = listaDeWheels.where((wheels)=>wheels.cupos>0).toList();

  for (var i = 0; i < listaDeWheels.length; i++) {
    if (listaDeWheels[i].listaPasajeros != null) {
      for (int j = 0;
          j < listaDeWheels[i].listaPasajeros.length && !encontrado;
          j++) {
        pasajero = await getPerfilDePasajero(
            listaDeWheels[i].listaPasajeros[j].perfil);

        if (pasajero.correo == p.correo &&
            (listaDeWheels[i].estado == 'espera' ||
                listaDeWheels[i].estado == 'transcurso')) {
          listaDeWheels[i].setSeleccionado(true);
          p.setTieneWheels(true);
          encontrado = true;
        }
      }
    }
    Profile perfilEste =
        listaDeWheels[i].profile = await getProfile(profileRef[i].path);
    if (perfilEste.correo == p.correo &&
        (listaDeWheels[i].estado == 'espera' ||
            listaDeWheels[i].estado == 'transcurso')) {
      listaDeWheels[i].setCreado(true);
      p.setTieneWheels(true);
    }
    listaDeWheels[i].referencia = referencias[i].documentID;
    revisarWheelsSentido(listaDeWheels[i]);
    revisarYSacarPositionUni(listaDeWheels[i].profile);
    revisarYSacarPositionCasa(listaDeWheels[i].profile);
    revisarWheelsFechaPartida(listaDeWheels[i]);
  }

  return listaDeWheels;
}

//devuelve un perfil
Future<Profile> getProfile(String login, String password, String token) async {
  DocumentSnapshot a = (await Firestore.instance
          .collection("usuarios")
          .where('correo', isEqualTo: login)
          .getDocuments())
      ?.documents[0];

  Firestore.instance
      .collection("usuarios")
      .document(a.documentID)
      .updateData({'token': token});

  Profile perfil = Profile.cargarJson(a);
  perfil.setReferencia(a.reference);
  perfil.setTieneWheels(false);

  if (perfil.latitud == null || perfil.longitud == null) {
    Position posicion = await getPositionAddres(perfil.direccion);
    perfil.setCasa(posicion);
    await Firestore.instance
        .collection("usuarios")
        .document(a.documentID)
        .updateData({'latitud': latitud});
    print(a.documentID);
    await Firestore.instance
        .collection("usuarios")
        .document(a.documentID)
        .updateData({'longitud': longitud});

    print("guardó latitud y longitud");
  }

  revisarYSacarPositionUni(perfil);
  revisarYSacarPositionCasa(perfil);
  return perfil;
}

List<Car> getCarros() {
  return <Car>[
    Car(modelo: 'Tesla Model S', placa: 'XYZ123', color: 'rojo'),
    Car(modelo: 'Tesla Model Y', placa: 'ABC987', color: 'verde')
  ];
}

//empezarWheels
void terminarWheels(Wheels wheels, Profile perfil) {
  Firestore.instance
      .collection('wheels')
      .document(wheels.referencia)
      .updateData({"estado": "finalizado"});
  perfil.setTieneWheels(false);
}

//empezarWheels
void empezarWheels(Wheels wheels) {
  DateTime b = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  Firestore.instance
      .collection('wheels')
      .document(wheels.referencia)
      .updateData({"estado": "transcurso", "fecha_transcurso": b});
}

void eliminarWheels(Wheels wheels, Profile perfil) {
  Firestore.instance
      .collection("wheels")
      .document(wheels.referencia)
      .updateData({"estado": "cancelado"});
  perfil.setTieneWheels(false);
}

Future<Wheels> crearWheels(int cupos, WheelsDirecion direction, String placa,
    TimeOfDay hora, String descripcion, Profile profile) async {
  DateTime b = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, hora.hour, hora.minute);
  var wheels = {
    "cupos": cupos,
    "descripcion": {
      "carro": {
        "color": profile.carros[0].color,
        "modelo": profile.carros[0].modelo,
        "placa": profile.carros[0].placa
      },
      "comentario": descripcion
    },
    "direccion": profile.direccion,
    "estado": "espera",
    "fecha_creacion": Timestamp.now(),
    "fecha_cupos_completados": null,
    "fecha_partida": b,
    "idConductor": profile.referencia,
    "localidad": profile.localidad,
    "pasajeros": [],
    "sentido": (direction == WheelsDirecion.casa_Uni) ? "hacia" : "desde"
  };
  var a =
      (await (await Firestore.instance.collection("wheels").add(wheels)).get())
          .documentID;
  profile.setTieneWheels(true);
  crearChatWheels(a);
  return Wheels(
      cupos: cupos,
      descripcion:
          Descripcion(carro: profile.carros[0], comentario: descripcion),
      direction: direction,
      fechaCreacion: Timestamp.now(),
      fechaCuposCompletados: null,
      fechaPartida: Timestamp.fromDate(b),
      profile: profile,
      hora: hora,
      creado: true,
      idWheels: a);
}

void crearChatWheels(String idWheels) {
  Firestore.instance
      .collection('wheels')
      .document(idWheels)
      .collection('chat')
      .document()
      .setData({});
}

Future<Profile> getPerfilDePasajero(DocumentReference perfil) async {
  DocumentSnapshot a = await Firestore.instance.document(perfil.path).get();
  return Profile.cargarJson(a);
}

typedef void WheelsReload(Wheels wheel);
void listener123(String idWheels, WheelsReload wheelsReload) {
  Firestore.instance
      .collection("wheels")
      .document(idWheels)
      .snapshots()
      .listen((DocumentSnapshot d) {
    var w = Wheels.cargarJson(d);
    wheelsReload(w);
  });
}

//de aqui para abajo es procesamiento de datos
void revisarWheelsSentido(Wheels w) {
  if (w.sentido.isNotEmpty) {
    if (w.sentido == "hacia") {
      w.setDirection(WheelsDirecion.casa_Uni);
    } else {
      w.setDirection(WheelsDirecion.uni_casa);
    }
  }
}

void revisarWheelsFechaPartida(Wheels w) {
  if (w.hora == null) {
    DateTime a = w?.fechaPartida?.toDate();

    int ho = a.hour;
    int mi = a.minute;

    TimeOfDay hora = TimeOfDay(hour: ho, minute: mi);
    w.setHora(hora);
  }
}

void revisarYSacarPositionCasa(Profile p) {
  if (p.casa == null) {
    p.setCasa(Position(lat: p.latitud, lng: p.longitud));
  }
}

void revisarYSacarPositionUni(Profile p) {
  switch (p.universidad) {
    case 'Los Andes':
      p.setUni(geoUniandes);
      break;
    case 'Universidad de los Andes':
      p.setUni(geoUniandes);
      break;
    default:
      print("universidad invalida");
  }
}
