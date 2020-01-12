import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';

import '../../models/streams/streamPerfil.dart';

import '../../models/DAOS/DAOS.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Locality extends StatefulWidget {
  const Locality({@required this.perfil});
  final Profile perfil;
  @override
  State<StatefulWidget> createState() => _LocalityState();
}

class _LocalityState extends State<Locality> {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  static final localidades =  [
                      "Chapinero",
            "Usaquén",
            "Santa Fé",
            "San Cristobal",
            "Usme",
            "Tunjuelito",
            "Bosa",
            "Kennedy",
            "Fontibón",
            "Engativá",
            "Suba",
            "Barrios Unidos",
            "Teusaquillo",
            "Los Mártires",
            "Antonio Nariño",
            "Puente Aranda",
            "La Candelaria",
            "Rafael Uribe Uribe",
            "Ciudad Bolivar",
            "Sumapaz"
                    ];
  Type name = Locality;
  String _localidad = "Sumapaz";

@override
  initState() {
    super.initState();
    _localidad = widget.perfil.localidad;
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
                          "Localidad",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: ScreenUtil.getInstance().setSp(45)),
                        ),
                        DropdownButton<String>(
                    items: localidades.map((String value)=> DropdownMenuItem<String>(
                        value: value,
                        child: Text("$value"),
                      )
                    ).toList(),
                    onChanged: (String changedValue) {
                      setState(() {
                        _localidad = changedValue;
                      });
                    },
                    value: _localidad,
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
                          Profile act = widget.perfil;
                          act.localidad = _localidad;
                          PerfilStream().update(act);
                          Navigator.pop(context);
                        } : null))
                  ],
                )
              ],
            )));
  }
}
