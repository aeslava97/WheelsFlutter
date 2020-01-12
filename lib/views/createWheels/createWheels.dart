import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';

import '../../viewModel/createWheels.dart';
import '../../viewModel/home.dart';
import '../../models/dataAccess.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../views/myMap.dart';
import '../../models/DAOS/DAOS.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateCreateWheels extends State<CreateWheels> {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  TimeOfDay hour = TimeOfDay.now();
  TimeOfDay selectedTimeRTL;
  TextEditingController _controller = TextEditingController();
  String placaCarro;
  int cuposWheels;
  Car carroEscogido;
  bool _isButtonDisabled = false;
  BaseView base;

  @override
  initState() {
    super.initState();
    placaCarro = widget.profile.carros[0].placa;
  }

  String toDir() {
    return (widget.wheelsDir != WheelsDirecion.casa_Uni)
        ? "Ir a casa"
        : "Ir a la U";
  }

  Position toPos() {
    return (widget.wheelsDir != WheelsDirecion.casa_Uni)
        ? widget?.profile?.casa
        : widget?.profile?.uni;
  }

  String getHora() {
    if (hour == null) return "NONE";
    return '${hour.hour != 12 ? hour.hour % 12 : 12}:${hour.minute < 10 ? '0' : ''}${hour.minute} ${(hour.hour < 12) ? 'am' : 'pm'}';
  }

  void click() {
    if (!_isButtonDisabled) {
      _isButtonDisabled = true;
      var a = () async {
        if (hour.hour < TimeOfDay.now().hour || (hour.hour == TimeOfDay.now().hour && hour.minute < TimeOfDay.now().minute)) {
          base.showError("ingresar hora valida por favor");
          return;
        }
        Wheels a = await crearWheels(
            (cuposWheels == null) ? 2 : cuposWheels,
            widget.wheelsDir,
            placaCarro,
            hour,
            _controller.text,
            widget.profile);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      profile: widget.profile,
                    )));
      };
      a();
    }
  }

  Widget rowDeHoraSalida() {
    return Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                TimeOfDay selectedTimeRTL = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget child) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: child,
                    );
                  },
                );
                setState(() {
                  if (selectedTimeRTL != null) {
                    hour = selectedTimeRTL;
                  }
                });
              },
              child: Text(
                getHora(),
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(60),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget rowDeCarro() {
    return Row(children: <Widget>[
      Text("carro: "),
      DropdownButton<String>(
        hint: Text('Escoge'),
        items: widget.profile.carros.map((Car value) {
          return new DropdownMenuItem<String>(
            value: value.placa,
            child: new Text(value.placa),
          );
        }).toList(),
        onChanged: (String changedValue) {
          setState(() {
            placaCarro = changedValue;
            carroEscogido = widget.profile.carros
                .where((Car c) => c.placa == placaCarro)
                .toList()[0];
          });
        },
        value: placaCarro,
      )
    ]);
  }

  Widget rowDeCupos() {
    return Row(
      children: <Widget>[
        Text("Cupos: "),
        DropdownButton<int>(
          hint: Text('2'),
          items: [1, 2, 3, 4, 5, 6].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text("$value"),
            );
          }).toList(),
          onChanged: (int changedValue) {
            setState(() {
              cuposWheels = changedValue;
            });
          },
          value: cuposWheels,
        )
      ],
    );
  }

  Widget rowDeDescripcion() {
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            height: ScreenUtil.getInstance().setHeight(400),
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil.getInstance().setWidth(20),
              vertical: ScreenUtil.getInstance().setHeight(20),
            ),
            child: TextField(
              maxLength: 1000,
              maxLines: 6,
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'nos vemos en la entrada del sd, tengo camisa azul',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
        )
      ],
    );
  }

  Widget alignBotonConfirmar() {
    return Align(
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
                            fontSize: ScreenUtil.getInstance().setSp(60)),
                      ),
                      onPressed: hasConnection ? click : null,
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    base = BaseView(scaffold: BaseScaffold(
      scaffoldState: _scaffoldState,
      appBar: AppBar(
        title: Text(toDir(),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: MyMap(Key(toPos().toString()),
                  positions: [widget.profile.casa, widget.profile.uni])),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil.getInstance().setWidth(50),
                vertical: ScreenUtil.getInstance().setHeight(50)),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  rowDeCarro(),
                  rowDeCupos(),
                  rowDeHoraSalida()
                ],
              ),
              rowDeDescripcion(),
              alignBotonConfirmar()
            ]),
          )
        ],
      ),
    ));
    return base;
  }
}
