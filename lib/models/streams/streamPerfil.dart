import 'dart:async';
import 'dart:core';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../DAOS/DAOS.dart';
class PerfilStream {
  static PerfilStream _singleton;
  DocumentReference ref;
  BehaviorSubject<Profile> _profileStream = new BehaviorSubject<Profile>();

  factory PerfilStream({String idPerfil}) {
    if (_singleton == null && idPerfil != null) {
      _singleton = PerfilStream._private(idPerfil);
    }
    return _singleton;
  }

  Stream<Profile> get perfilStream => _profileStream.stream;

  Profile get perfil => _profileStream.value;

  void update(Profile act){
    ref.updateData(act.toJson());
  }

  dispose() {
    _profileStream.close();
  }

  static final StreamTransformer<DocumentSnapshot, Profile> profiler =
      new StreamTransformer.fromHandlers(
          handleData: (DocumentSnapshot data, EventSink sink) {
    sink.add(Profile.cargarJson(data));
  });

  PerfilStream._private(String idPerfil) {
    ref = Firestore.instance.collection("usuarios").document(idPerfil);
    ref.snapshots().transform(profiler).pipe(_profileStream);
  }
}