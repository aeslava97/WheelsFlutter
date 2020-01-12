import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';

import '../models/streams/streamPerfil.dart';
import '../views/profileThings/direction.dart';
import '../views/profileThings/locality.dart';
import '../views/profileThings/sex.dart';
import './profileThings/name.dart';
import './profileThings/phone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/DAOS/DAOS.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  Widget imagen() {
    return Icon(
      Icons.account_circle,
      color: Colors.black,
      size: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return BaseScaffold(
        scaffoldState: _scaffoldState,
        appBar: AppBar(
          title: Text("Mi Cuenta"),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: PerfilStream().perfilStream,
            builder: (BuildContext context, AsyncSnapshot<Profile> snap) {
              if (snap.hasData) {
                Profile perfil = snap.data;
                return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil.getInstance().setWidth(40)),
                    child: ListView(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            imagen(),
                            Divider(
                              thickness: 1,
                            ),
                            Text(
                              "Correo (no modificable)",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: ScreenUtil.getInstance().setSp(45)),
                            ),
                            FlatButton(
                                child: Text(perfil.correo), onPressed: () {}),
                            Text(
                              "Nombre",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: ScreenUtil.getInstance().setSp(45)),
                            ),
                            BuilderConnection(
                                builder: (BuildContext context,
                                        bool hasConnection) =>
                                    FlatButton(
                                        child: Text(perfil.nombre),
                                        onPressed: !hasConnection ? null : () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Name(perfil: perfil)));
                                        })),
                            Text(
                              "Telefono",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: ScreenUtil.getInstance().setSp(45)),
                            ),
                            BuilderConnection(
                                builder: (BuildContext context,
                                        bool hasConnection) =>
                                    FlatButton(
                                        child: Text(perfil.telefono.toString()),
                                        onPressed: !hasConnection ? null : () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Phone(perfil: perfil)));
                                        })),
                            Text(
                              "Dirección",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: ScreenUtil.getInstance().setSp(45)),
                            ),
                            BuilderConnection(
                                builder: (BuildContext context,
                                        bool hasConnection) =>
                                    FlatButton(
                                        child: Text(perfil.direccion),
                                        onPressed: !hasConnection ? null : () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Direction(
                                                          perfil: perfil)));
                                        })),
                            Text(
                              "Localidad",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: ScreenUtil.getInstance().setSp(45)),
                            ),
                            BuilderConnection(
                                builder: (BuildContext context,
                                        bool hasConnection) =>
                                    FlatButton(
                                        child: Text(perfil.localidad),
                                        onPressed: !hasConnection ? null : () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Locality(
                                                          perfil: perfil)));
                                        })),
                            Text(
                              "Sexo",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: ScreenUtil.getInstance().setSp(45)),
                            ),
                            BuilderConnection(
                                builder: (BuildContext context,
                                        bool hasConnection) =>
                                    FlatButton(
                                        child: Text(perfil.sexo),
                                        onPressed: !hasConnection ? null : () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Sex(
                                                      perfil: perfil,
                                                      key: UniqueKey())));
                                        })),
                          ],
                        )
                      ],
                    ));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
