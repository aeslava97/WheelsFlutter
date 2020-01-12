import 'package:ej/models/streams/connectivity.dart';

import '../../models/streams/streamPerfil.dart';

import '../../models/DAOS/DAOS.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sex extends StatefulWidget {
  const Sex({@required this.perfil,Key key});
  final Profile perfil;

  @override
  State<StatefulWidget> createState() => _SexState();
}

class _SexState extends State<Sex> {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  String _radiobutton;

  Type name = Sex;

@override
  initState() {
    super.initState();
    _radiobutton = widget.perfil.sexo;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return Scaffold(
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
                    Row(
                    children: <Widget>[
                      Expanded(
                          child: ListTile(
                        title: const Text('Hombre'),
                        leading: Radio(
                          value: "Hombre",
                          groupValue: _radiobutton,
                          onChanged: (String value) {
                            setState(() {
                              _radiobutton = value;
                            });
                          },
                        ),
                      )),
                      Expanded(
                          child: ListTile(
                        title: const Text('Mujer'),
                        leading: Radio(
                          value: "Mujer",
                          groupValue: _radiobutton,
                          onChanged: (String value) {
                            setState(() {
                              _radiobutton = value;
                            });
                          },
                        ),
                      ))
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
                          Profile act = widget.perfil;
                          act.sexo = _radiobutton;
                          PerfilStream().update(act);
                          Navigator.pop(context);
                        } : null))
                  ],
                )
              ],
            )));
  }
}
