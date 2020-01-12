import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';


class PushNotificatorProvider{
   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
   final _mensajesStreamController = StreamController<String>.broadcast();
   Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotification(){
    //_firebaseMessaging.requestNotificationPermissions();

    //_firebaseMessaging.getToken().then((token){

       // Firestore.instance.collection("usuarios");
    //});

    _firebaseMessaging.configure(
      onMessage: ( info ){
        print ("---------ONMessage--------------");
        print(info);

        String argumento = info['notification']['body'] ?? 'no-data';
        print(argumento);
        _mensajesStreamController.sink.add(argumento);
      },
      onLaunch: (info){
        print ("---------OnLaunch--------------");
        print(info);
      },
      onResume: (info){
        print ("---------On Resume--------------");
        print(info);
        String argumento = info['notificacion']['body']?? 'no-data';
        _mensajesStreamController.sink.add(argumento);

      }
    );

  }

  dispose(){
      _mensajesStreamController?.close();
  }

}