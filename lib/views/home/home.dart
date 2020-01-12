import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';
import '../../viewModel/confirmWheels.dart';
import '../../viewModel/home.dart';
import '../../viewModel/createdWheels.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../viewModel/createWheels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../models/dataAccess.dart';
import '../myProfile.dart';
import '../../models/DAOS/DAOS.dart';
import '../../viewModel/createCar.dart';
import '../../models/permisos.dart';

class HomeState extends State<Home> {
  bool esConductor = false;
  bool pruebaDeRender = false;
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  final List<WheelsDirecion> dir = [
    WheelsDirecion.uni_casa,
    WheelsDirecion.casa_Uni
  ];

  int _selectedIndex = 0;

  void _siEsConductor(bool a) {
    setState(() {
      esConductor = a;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Null> cambiarEstadoParaRender() async {
    setState(() {
      pruebaDeRender = !pruebaDeRender;
    });
    return null;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Seguro?'),
            content: Text('Se saldrá de la aplicación'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('SI'),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  Widget drawerMostrar() {
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            DrawerHeader(
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 80,
                  )),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil.getInstance().setHeight(10)),
                            child: Text(widget.profile.nombre,
                                style: TextStyle(color: Colors.white),
                                textScaleFactor: 1.4)),
                        Row(
                          children: <Widget>[
                            Text("4,57",
                                style: TextStyle(color: Colors.grey[300])),
                            Icon(Icons.grade, color: Colors.grey[300])
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(color: Colors.black),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.getInstance().setWidth(20),
                    vertical: ScreenUtil.getInstance().setHeight(10)),
                child: FlatButton(
                    child: Text(
                      "Mi Perfil",
                      textScaleFactor: 1.3,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyProfile()),
                      );
                    })),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.getInstance().setWidth(20),
                    vertical: ScreenUtil.getInstance().setHeight(10)),
                child: FlatButton(
                    child: Text(
                      "Agregar Carro",
                      textScaleFactor: 1.3,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateCar(
                                widget.profile, dir[_selectedIndex], false)),
                      );
                    })),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.getInstance().setWidth(20),
                    vertical: ScreenUtil.getInstance().setHeight(10)),
                child: FlatButton(
                    child: Text(
                      "Historial",
                      textScaleFactor: 1.3,
                    ),
                    onPressed: () {}))
          ],
        ),
        Column(
          children: <Widget>[
            Divider(thickness: 1),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.getInstance().setWidth(20),
                    vertical: ScreenUtil.getInstance().setHeight(10)),
                child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.settings),
                        Text(
                          "Configuracion",
                          textScaleFactor: 1.3,
                        )
                      ],
                    ),
                    onPressed: () {}))
          ],
        )
      ],
    ));
  }

  Widget elFutureBuilderDeContent() {
    return FutureBuilder(
      future: getWheels(dir[_selectedIndex], widget.profile),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _Contend(
            profile: widget.profile,
            wheels: snapshot.data,
            funcionParaCambiarRender: cambiarEstadoParaRender,
            key: UniqueKey(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //checkearInternet();

    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return BaseView(
        scaffold: BaseScaffold(
            scaffoldState: _scaffoldState,
            drawer: drawerMostrar(),
            appBar: AppBar(
              actions: <Widget>[
                Column(
                  children: <Widget>[
                    Text("¿conductor?"),
                    Flexible(
                        child: Switch(
                      onChanged: (bool value) {
                        _siEsConductor(value);
                      },
                      value: esConductor,
                      inactiveTrackColor: Colors.grey,
                    ))
                  ],
                )
              ],
              automaticallyImplyLeading: true,
              title: Text(widget.profile.direccion,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0)),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: WillPopScope(
                child: elFutureBuilderDeContent(), onWillPop: _onBackPressed),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey[300],
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Ir a Casa'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  title: Text('Ir a Uniandes'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              onTap: _onItemTapped,
            ),
            floatingActionButton: BotonConductor(
              esConductor: esConductor,
              profile: widget.profile,
              wheelsDir: dir[_selectedIndex],
            )));
  }
}

class _Contend extends StatelessWidget {
  const _Contend(
      {@required this.profile,
      @required this.wheels,
      this.funcionParaCambiarRender,
      Key key});
  final List<Wheels> wheels;
  final Profile profile;
  final Function funcionParaCambiarRender;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil.getInstance().setWidth(10),
            vertical: ScreenUtil.getInstance().setWidth(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.filter_list,
            ),
          ],
        ),
      ),
      Divider(height: 10),
      Expanded(
          child: RefreshIndicator(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: wheels.length,
          itemBuilder: (BuildContext context, int index) {
            var a = wheels[index];

            return WheelView(wheels: a, profile: profile);
          },
        ),
        onRefresh: funcionParaCambiarRender,
      ))
    ]);
  }
}

class StateWheelView extends State<WheelView> {
  bool siEs = false;

  String getHora(TimeOfDay hour) {
    if (hour == null) return "NONE";
    return '${hour.hour != 12 ? hour.hour % 12 : 12}:${hour.minute < 10 ? '0' : ''}${hour.minute} ${(hour.hour < 12) ? 'am' : 'pm'}';
  }

  String toDir() {
    return (widget.wheels.direction == WheelsDirecion.casa_Uni)
        ? widget.wheels.profile.universidad
        : widget.wheels.profile.direccion;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);

    return GestureDetector(
        onTap: () async {
          PermissionService().requestLocationPermission(onPermissionDenied: () {
            print('Permisos denegados');
          });
          bool result = await DataConnectionChecker().hasConnection;
          if (result == false) {
            final snackBar =
                SnackBar(content: Text("No hay conexión a internet"));
            Scaffold.of(context).showSnackBar(snackBar);
          } else {
            if (widget.wheels.seleccionado == true ||
                widget.wheels.creado == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatedWheels(
                          profileUsuario: widget.profile,
                          profileConductor: widget.wheels.profile,
                          wheels: widget.wheels,
                        )),
              );
            } else {
              if (widget.profile.tieneWheels == false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmWheels(
                          wheels: widget.wheels,
                          perfil: widget.profile)),
                );
              } else {
                final snackBar = SnackBar(
                    content:
                        Text("Lo sentimos, ya está vinculado a un wheels"));
                Scaffold.of(context).showSnackBar(snackBar);
              }
            }
          }
        },
        child: Container(
            decoration: BoxDecoration(
                color: ((widget.wheels.getSeleccionado() == true)
                    ? Colors.greenAccent
                    : widget.wheels.creado == true
                        ? Colors.amberAccent
                        : Colors.transparent)),
            child: Card(
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil.getInstance().setWidth(25),
                      vertical: ScreenUtil.getInstance().setHeight(25)),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          toDir(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getHora(widget.wheels.hora),
                          style: TextStyle(
                              fontSize:
                                  ScreenUtil(allowFontScaling: true).setSp(40)),
                        ),
                      ],
                    ),
                    Divider(height: ScreenUtil.getInstance().setHeight(12)),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            child: Text(
                          'Cupos: ${widget.wheels.cupos}',
                          style: TextStyle(
                              fontSize:
                                  ScreenUtil(allowFontScaling: true).setSp(40)),
                        )))
                  ]),
                ))));
  }
}

class BotonConductor extends StatelessWidget {
  BotonConductor({this.esConductor, this.profile, this.wheelsDir});
  Profile profile;
  final bool esConductor;
  WheelsDirecion wheelsDir;

  @override
  Widget build(BuildContext context) {
    if (esConductor) {
      return BuilderConnection(
          builder: (BuildContext context, bool hasConnection) =>
              FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: hasConnection
                      ? () {
                          if (profile.tieneWheels == false) {
                            if (hasCars(profile)) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateWheels(
                                          wheelsDir: wheelsDir,
                                          profile: profile,
                                        )),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateCar(profile, wheelsDir, true)),
                              );
                            }
                          } else {
                            BaseView.of(context).showError(
                                "Lo sentimos, ya está vinculado a un wheels");
                          
                          }
                        }
                      : null,
                  child: hasConnection
                      ? Text("+",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0))
                      : Icon(Icons.signal_wifi_off)
                      ));
    } else {
      return Container();
    }
  }
}
