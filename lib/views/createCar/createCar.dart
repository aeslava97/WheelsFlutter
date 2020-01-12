import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';
import '../../viewModel/home.dart';
import '../../viewModel/createWheels.dart';
import '../../models/dataAccess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../viewModel/createCar.dart';

class CreateCarState extends State<CreateCar> {
  static final GlobalKey<ScaffoldState> _scaffoldkey =
      new GlobalKey<ScaffoldState>();
  String _placa, _modelo, _color;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final botonEnviar = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: BuilderConnection(builder: (BuildContext context, bool hasConection) => MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: hasConection ? () {
            crearCarro();
          } : null,
          child: Text(
            'REGISTER CAR',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
    ));
    final placaField = TextFormField(
      validator: (input) {
        if (input.isEmpty) {
          return 'provide a car registration';
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Placa',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: false,
      style: style,
      onSaved: (input) => _placa = input,
    );
    final modelField = TextFormField(
      validator: (input) {
        if (input.isEmpty) {
          return 'provide an model';
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Modelo',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: false,
      style: style,
      onSaved: (input) => _modelo = input,
    );
    final colorField = TextFormField(
      validator: (input) {
        if (input.isEmpty) {
          return 'provide a color';
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Color',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: false,
      style: style,
      onSaved: (input) => _color = input,
    );
    return BaseView(
        scaffold: BaseScaffold(
            scaffoldState: _scaffoldkey,
            appBar: new AppBar(backgroundColor: Colors.black),
            body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        placaField,
                        SizedBox(height: 10.0),
                        modelField,
                        SizedBox(height: 10.0),
                        colorField,
                        SizedBox(height: 10.0),
                        botonEnviar
                      ],
                    ),
                  )),
            )));
  }

  crearCarro() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        createCarro(widget.perfil, _color, _modelo, _placa);
        if (widget.crearWheels) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateWheels(
                      profile: widget.perfil, wheelsDir: widget.wheels)));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(profile: widget.perfil)));
        }
      } catch (e) {
        BaseView.of(context).showError(e.message);
      }
    }
  }
}
