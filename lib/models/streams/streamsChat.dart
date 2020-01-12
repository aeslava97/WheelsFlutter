import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/DAOS/chat.dart';
import 'package:rxdart/subjects.dart';

class ChatStream {
  static ChatStream _singleton;
  CollectionReference ref;
  StreamController<List<Chat>> _chatStream = new BehaviorSubject<List<Chat>>();

  factory ChatStream({String idWheels}) {
    var id;
    if ((_singleton == null && idWheels != null) || (id != idWheels &&  idWheels != null && _singleton != null)) {
      _singleton = ChatStream._private(idWheels);
      id=idWheels;
    }
    return _singleton;
  }

  Stream<List<Chat>> get chat => _chatStream.stream;

  void add(Chat act) {
    var a = Firestore.instance
        .collection("usuarios")
        .document(act.idPerfil);
    act.idEmisor = a;
    ref.add(act.toJson());
  }

  dispose() {
    _chatStream.close();
  }

  static final StreamTransformer<QuerySnapshot, List<Chat>> chatfiler =
      new StreamTransformer.fromHandlers(
          handleData: (QuerySnapshot data, EventSink sink) {
            data.documents.forEach((DocumentSnapshot doc){print(doc.data);print(Chat.cargarJson(doc));});
    var a = data.documents.map((DocumentSnapshot doc) => Chat.cargarJson(doc)).toList();
    sink.add(a);
  });

  ChatStream._private(String idWheels) {
    ref = Firestore.instance
        .collection("wheels")
        .document(idWheels)
        .collection("chat");
    ref
        .orderBy('fecha', descending: false)
        .snapshots()
        .transform(chatfiler)
        .pipe(_chatStream);
  }
}
