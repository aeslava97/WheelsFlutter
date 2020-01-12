import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';
import '../../viewModel/confirmWheels.dart';
import '../../models/dataAccess.dart';
import '../../models/DAOS/DAOS.dart';
import '../../viewModel/createdWheels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoder/model.dart';
import '../myMap.dart';

import 'package:flutter/material.dart';

class StateConfirmWheels extends State<ConfirmWheels> {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
      static final GlobalKey<ScaffoldState> _scaffoldState2 =
      new GlobalKey<ScaffoldState>();
  final MyMapController _mapController = MyMapController();
  final _textController = TextEditingController();

  Position _finalPosition() {
    return (widget.wheels.direction == WheelsDirecion.casa_Uni)
        ? widget.wheels.profile.uni
        : widget.wheels.profile.casa;
  }

  Position _initPosition() {
    return (widget.wheels.direction == WheelsDirecion.casa_Uni)
        ? widget.wheels.profile.casa
        : widget.wheels.profile.uni;
  }

  // String _finalDir() {
  //   return (wheels.direction == WheelsDirecion.casa_Uni)
  //       ? wheels.profile.universidad
  //       : wheels.profile.direccion;
  // }

  String getHora() {
    var hour = widget.wheels?.hora;
    if (hour == null) return "NONE";
    return '${hour.hour != 12 ? hour.hour % 12 : 12}:${hour.minute < 10 ? '0' : ''}${hour.minute} ${(hour.hour < 12) ? 'am' : 'pm'}';
  }

//Se añaden las posiciones al array positions que se manda al mapa
  List<Position> getPositions() {
    List<Position> positions = [];
    positions.addAll([_finalPosition(), _initPosition()]);

    return positions;
  }

//esto es para crear la key para ponerse luego al mapa y que este se mueva
  String calculateKey(List<Position> positions) {
    String key = 'none';
    if (positions.isNotEmpty) {
      key = positions
          ?.reduce((acum, act) =>
              Position(lat: acum.lat + act.lat, lng: acum.lng + act.lng))
          ?.toString();
    }
    return key;
  }

  Widget rowDeHoraSalida() {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil.getInstance().setWidth(20),
                vertical: ScreenUtil.getInstance().setHeight(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Salida: "),
                Text(getHora(),
                    style:
                        TextStyle(fontSize: ScreenUtil.getInstance().setSp(60)))
              ],
            )));
  }

  Widget rowDeCupos() {
    return Row(
      children: <Widget>[
        Text("Cupos disponibles: "),
        Text(widget.wheels.cupos.toString())
      ],
    );
  }

  void llamadoAgetAddress() async {
    double lat = _mapController.centerMarkerlat;
    double lng = _mapController.centerMarkerLng;
    Address address = await getAddressPosition(lat, lng);
    _textController.text = address.addressLine;
    print(_textController.text);
  }

  Widget rowDelTextfield() {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil.getInstance().setWidth(10),
            vertical: ScreenUtil.getInstance().setHeight(10)),
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "punto de recogida"),
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("wheels")
            .document(widget.wheels.idWheels)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {
          if (!snap.hasData) {
            return Container();
          }
          if (snap.data["estado"] == "cancelado") {
            return BaseScaffold(
              scaffoldState: _scaffoldState2,
              appBar: AppBar(
                title: const Text("Wheels",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0)),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Text("Lo sentimos, este wheels fue cancelado"),
                    FlatButton(
                      color: Colors.black,
                      child: Text("volver atras",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            );
          } else {
            return BaseScaffold(
                scaffoldState: _scaffoldState,
                appBar: AppBar(
                  title: const Text("Wheels",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0)),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                ),
                body: _content(context));
          }
        });
  }

  Widget _content(BuildContext context) {
    llamadoAgetAddress();
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return Column(
      children: <Widget>[
        Divider(height: ScreenUtil.getInstance().setHeight(12)),
        Flexible(
            child: Stack(
          children: <Widget>[
            MyMap(
              Key(calculateKey(getPositions())),
              positions: getPositions(),
              controller: _mapController,
            ),
            Center(
                child: Container(
                    child: Icon(Icons.add_location, size: 50),
                    padding: EdgeInsets.only(bottom: 40))),
            Row(
              children: <Widget>[
                Expanded(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: rowDeHoraSalida()))
              ],
            )
          ],
        )),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.getInstance().setWidth(20),
              vertical: ScreenUtil.getInstance().setHeight(20)),
          child: Column(
            children: <Widget>[
              Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[rowDeCupos(), rowDelTextfield()],
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.getInstance().setWidth(40)),
                      child: BuilderConnection(
                          builder: (BuildContext context, bool hasConnection) =>
                              FlatButton(
                                color: Colors.black,
                                child: Text(
                                  "confirmar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(60)),
                                ),
                                onPressed: hasConnection
                                    ? () async {
                                        reservarWheels(
                                            widget.wheels, widget.perfil);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreatedWheels(
                                                      profileConductor:
                                                          widget.wheels.profile,
                                                      profileUsuario:
                                                          widget.perfil,
                                                      wheels: widget.wheels,
                                                    )));
                                      }
                                    : null,
                              ))))
            ],
          ),
        )
      ],
    );
  }
}
