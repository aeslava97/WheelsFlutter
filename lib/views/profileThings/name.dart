import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';

import '../../models/streams/streamPerfil.dart';

import '../../models/DAOS/DAOS.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Name extends StatefulWidget {
  const Name({@required this.perfil});
  final Profile perfil;
  @override
  State<StatefulWidget> createState() => _NameState();
}

class _NameState extends State<Name> {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  TextEditingController _controller;
  Type name = Name;
  String error;

  @override
  initState() {
    super.initState();
    _controller = TextEditingController(text: widget.perfil.nombre);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return BaseScaffold(
      scaffoldState: _scaffoldState,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil.getInstance().setWidth(100),
                vertical: ScreenUtil.getInstance().setHeight(500)),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Nombre",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: ScreenUtil.getInstance().setSp(45)),
                        ),
                        TextField(
                          controller: _controller,
                          maxLength: 100,
                          decoration: InputDecoration(errorText: error),
                        ),
                      ],
                    ),
                    BuilderConnection(
                builder: (BuildContext context, bool hasConnection) => FlatButton(
                        color: Colors.black,
                        child: Text(
                          "Guardar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.getInstance().setSp(60)),
                        ),
                        onPressed: hasConnection ? () {
                          if (_controller.text.isEmpty) {
                            setState(() {
                              error = "no puede ser vacío";
                            });
                          } else {
                            Profile act = widget.perfil;
                            act.nombre = _controller?.text;
                            PerfilStream().update(act);
                            Navigator.pop(context);
                          }
                        } : null))
                  ],
                )
              ],
            )));
  }
}
