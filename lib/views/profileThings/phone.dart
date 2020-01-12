import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';

import '../../models/streams/streamPerfil.dart';

import '../../models/DAOS/DAOS.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:validators/validators.dart';

class Phone extends StatefulWidget {
  const Phone({@required this.perfil});
  final Profile perfil;
  @override
  State<StatefulWidget> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  TextEditingController _controller;
  Type name = Phone;
  String error;
  @override
  initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.perfil.telefono.toString());
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
                          "Telefono",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: ScreenUtil.getInstance().setSp(45)),
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _controller,
                            decoration: InputDecoration(errorText: error),
                            maxLength: 100,
                            validator: (input) {
                              if (!isNumeric(input)) {
                                return 'digite un número válido';
                              }
                            }),
                      ],
                    ),
                    BuilderConnection(
                        builder: (BuildContext context, bool hasConnection) =>
                            FlatButton(
                                color: Colors.black,
                                child: Text(
                                  "Guardar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(60)),
                                ),
                                onPressed: hasConnection
                                    ? () {
                                        Profile act = widget.perfil;
                                        try {
                                          act.telefono =
                                              int.parse(_controller?.text);
                                          PerfilStream().update(act);
                                          Navigator.pop(context);
                                        } catch (e) {
                                          setState(() {
                                            error = "solo números por favor";
                                          });
                                        }
                                      }
                                    : null))
                  ],
                )
              ],
            )));
  }
}
