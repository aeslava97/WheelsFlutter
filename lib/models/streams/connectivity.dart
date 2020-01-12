import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:connectivity/connectivity.dart';

typedef Widget Constructor(BuildContext context, bool hasConnection);

class ConnectionStatus {
  final BehaviorSubject<bool> _connectionChangeController =
      BehaviorSubject<bool>();
  static final ConnectionStatus _singleton = ConnectionStatus._internal();

  bool hasConnection = false;

  ConnectionStatus._internal() {
    Connectivity().onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  static ConnectionStatus getInstance() => _singleton;
  ValueObservable<bool> get connectionChange =>
      _connectionChangeController.stream;

  void dispose() {
    _connectionChangeController.close();
  }

  static Widget widgetInternet(Constructor c) {
    return StreamBuilder(
      stream: ConnectionStatus.getInstance().connectionChange,builder: (BuildContext context, AsyncSnapshot<bool> snap){
        if (snap.hasData && snap.data) {
          return c(context, true);
        } else {
          return c(context, false);
        }
      },
    );
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      _connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}


class BuilderConnection extends StatelessWidget{
BuilderConnection({this.builder});
final Constructor builder;

  @override
  Widget build(BuildContext context) {
     return StreamBuilder(
      stream: ConnectionStatus.getInstance().connectionChange,builder: (BuildContext context, AsyncSnapshot<bool> snap){
        if (snap.hasData && snap.data) {
          return builder(context, true);
        } else {
          return builder(context, false);
        }
      },
    );
  }
  
}