import 'models/pushNotificationsProvider.dart';
import 'views/notificacion.dart';
import 'package:flutter/services.dart';
import 'views/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}

 class _MyAppState extends State<MyApp> {
   final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

   @override
   void initState(){
     super.initState();
     final pushProvider = new PushNotificatorProvider();
     pushProvider.initNotification();
     pushProvider.mensajes.listen((argumento){
       //Navigator.pushNamed(context, routeName)
       print("-----------------------");
       print(argumento);

       navigatorKey.currentState.popAndPushNamed('mensaje', arguments: argumento);
     });
   }

   @override
   Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      initialRoute: 'home',
      navigatorKey: navigatorKey,
      routes: {
        'home': (BuildContext context) => Login(),
        'mensaje': (BuildContext context) => Notificacion()
      },
      
      );
  }
 }


  

