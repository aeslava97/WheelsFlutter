import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';
import '../../models/streams/streamsChat.dart';
import '../../views/chat.dart';
import '../../models/dataAccess.dart';
import '../../viewModel/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../views/myMap.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/DAOS/DAOS.dart';
import '../../viewModel/createdWheels.dart';

class StateCreatedWheels extends State<CreatedWheels> {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  Wheels wheelsActual;
  @override
  initState() {
    super.initState();
    wheelsActual = widget.wheels;
    listener123(widget.wheels.idWheels, (Wheels w) {
      setState(() {
        wheelsActual = w;
      });
    });
  }

  String getHora(TimeOfDay hour) {
    if (hour == null) return "NONE";
    return '${hour.hour != 12 ? hour.hour % 12 : 12}:${hour.minute < 10 ? '0' : ''}${hour.minute} ${(hour.hour < 12) ? 'am' : 'pm'}';
  }

  Widget botonArrancar() {
    return BuilderConnection(
        builder: (BuildContext context, bool hasConnection) => FlatButton(
              color: Colors.green,
              child: Text(
                (widget.wheels.creado == true)
                    ? "Empezar Wheels"
                    : "Cancelar wheels",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.getInstance().setSp(30)),
              ),
              onPressed: hasConnection
                  ? () async {
                      empezarWheels(widget.wheels);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    profile: widget.profileUsuario,
                                  )));
                    }
                  : null,
            ));
  }

  Widget botonTerminar() {
    return BuilderConnection(
        builder: (BuildContext context, bool hasConnection) => FlatButton(
              color: Colors.red,
              child: Text(
                (widget.wheels.creado == true)
                    ? "Terminar wheels"
                    : "Cancelar wheels",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.getInstance().setSp(60)),
              ),
              onPressed: hasConnection
                  ? () async {
                      terminarWheels(widget.wheels, widget.profileUsuario);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    profile: widget.profileUsuario,
                                  )));
                    }
                  : null,
            ));
  }

  Widget botonCancelar() {
    return BuilderConnection(
        builder: (BuildContext context, bool hasConnection) => FlatButton(
              color: Colors.black,
              child: Text(
                (widget.wheels.creado == true)
                    ? "Eliminar wheels"
                    : "Cancelar wheels",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.getInstance().setSp(30)),
              ),
              onPressed: hasConnection
                  ? () async {
                      if (widget.wheels.creado == true) {
                        eliminarWheels(widget.wheels, widget.profileUsuario);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      profile: widget.profileUsuario,
                                    )));
                      } else {
                        cancerlarReserva(widget.wheels, widget.profileUsuario);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      profile: widget.profileUsuario,
                                    )));
                      }
                    }
                  : null,
            ));
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
                Text(
                    getHora(TimeOfDay(
                        hour: wheelsActual.fechaPartida.toDate().hour,
                        minute: wheelsActual.fechaPartida.toDate().minute)),
                    style:
                        TextStyle(fontSize: ScreenUtil.getInstance().setSp(60)))
              ],
            )));
  }

  Widget rowDeCarro() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.profileConductor.nombre,
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(70),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(wheelsActual.descripcion.carro.modelo),
                ],
              )),
          Column(
            children: <Widget>[
              SizedBox(
                  height: ScreenUtil.getInstance().setHeight(100),
                  width: ScreenUtil.getInstance().setWidth(300),
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.calendar_view_day),
                            Text(wheelsActual.descripcion.carro.placa)
                          ]))),
              Text(wheelsActual.descripcion.carro.color)
            ],
          )
        ]);
  }

  Widget rowComentario() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
            child: Text(
                (wheelsActual.descripcion.comentario == null)
                    ? "No hay descripción"
                    : wheelsActual.descripcion.comentario,
                maxLines: 4,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis))
      ],
    );
  }

  List<BotonesView> getPasajeros() {
    var a = wheelsActual?.listaPasajeros
        ?.map((x) => BotonesView(perfil: x))
        ?.toList();

    return (a != null) ? a : [];
  }

  Widget botonParaLlamar() {
    if (widget.profileConductor.correo != widget.profileUsuario.correo) {
      return FlatButton(
          color: Colors.white,
          child: Icon(Icons.call),
          shape: CircleBorder(side: BorderSide(width: 1)),
          onPressed: () {
            launch("tel:${widget.profileConductor.telefono}");
          });
    } else {
      // return ListView.builder(
      //   itemCount: widget.wheels?.listaPasajeros?.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     var a = widget.wheels?.listaPasajeros[index];
      //     return BotonesView(perfiles: a);
      //   },
      // );
      return Container(child: Column(children: getPasajeros()));
    }
  }

  Widget botonChat() {
    return FlatButton(
        color: Colors.white,
        child: Icon(Icons.chat),
        shape: CircleBorder(side: BorderSide(width: 1)),
        onPressed: () {
          ChatStream(idWheels: widget.wheels.idWheels);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatView(
                      nombre: widget.profileUsuario.nombre,
                      id: widget.profileUsuario.id)));
        });
  }

  //widget.wheels.descripcion.comentario
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return BaseScaffold(
        scaffoldState: _scaffoldState,
        appBar: AppBar(
          title: Text("Wheels",
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
                child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: MyMap(Key(widget.profileConductor.direccion),
                          positions: [
                            widget.profileConductor.casa,
                            widget.profileConductor.uni
                          ]),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        rowDeHoraSalida(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[botonParaLlamar()],
                    )
                  ],
                )
              ],
            )),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.getInstance().setWidth(10),
                    vertical: ScreenUtil.getInstance().setHeight(10)),
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.getInstance().setWidth(20),
                            vertical: ScreenUtil.getInstance().setHeight(20)),
                        child: Column(
                          children: <Widget>[
                            rowDeCarro(),
                            Divider(
                                thickness: 1,
                                height: ScreenUtil.getInstance().setHeight(12)),
                            Container(child: rowComentario())
                          ],
                        )))),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: (widget.wheels.creado)
                  ? (widget.wheels.estado == "espera")
                      ? <Widget>[botonArrancar(), botonCancelar(), botonChat()]
                      : <Widget>[botonTerminar(), botonChat()]
                  : <Widget>[botonCancelar(), botonChat()],
            )
          ],
        ));
  }
}

class BotonesView extends StatefulWidget {
  BotonesView({@required this.perfil});
  final Passenger perfil;

  @override
  State<StatefulWidget> createState() {
    return StateBotonesView();
  }
}

class StateBotonesView extends State<BotonesView> {
  bool presionado = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FlatButton(
            color: Colors.white,
            child: Icon(
              Icons.account_circle,
            ),
            shape: CircleBorder(side: BorderSide(width: 1)),
            onPressed: () {
              setState(() {
                presionado = !presionado;
              });
            }),
        presionado
            ? Container()
            : FutureBuilder(
                future: getPerfilDePasajero(widget.perfil.perfil),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: <Widget>[
                        FlatButton(
                            color: Colors.white,
                            child: Icon(Icons.call),
                            shape: CircleBorder(side: BorderSide(width: 1)),
                            onPressed: () {
                              Profile a = snapshot.data;
                              launch("tel:${a.telefono}");
                            })
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
      ],
    );
  }
}
