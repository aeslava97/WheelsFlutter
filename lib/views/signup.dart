import 'package:ej/general/BaseView.dart';
import 'package:ej/models/streams/connectivity.dart';
import 'package:synchronized/synchronized.dart';
import '../views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart';

class Signup extends StatefulWidget {
  const Signup();

  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  BaseView a;
  final users = Firestore.instance.collection("usuarios");
  static final GlobalKey<ScaffoldState> _scaffoldkey =
      new GlobalKey<ScaffoldState>();
  String _email, _password, _nombre, _telefono, _dir, _localidad;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final botonEnviar = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: BuilderConnection(
          builder: (BuildContext context, bool hasConnection) => MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: !hasConnection
                  ? null
                  : () async {
                      new Lock();
                      await signUp();
                    },
              child: Text(
                'REGISTER',
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ))),
    );
    final nombreField = TextFormField(
      maxLength: 100,
      validator: (input) {
        if (input.isEmpty) {
          return 'provide an name';
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Name',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: false,
      style: style,
      onSaved: (input) => _nombre = input,
    );
    final telefonoField = TextFormField(
      maxLength: 100,
      validator: (input) {
        if (!isNumeric(input)) {
          return 'digite un número válido';
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Phone',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: false,
      style: style,
      onSaved: (input) => _telefono = input,
    );
    final emailField = TextFormField(
      maxLength: 100,
      keyboardType: TextInputType.emailAddress,
      validator: (input) {
        if (input.isEmpty) {
          return 'provide an email';
        }
        if (!isEmail(input)) {
          return 'correo inválido';
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Email',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: false,
      style: style,
      onSaved: (input) => _email = input,
    );
    final passwordField = TextFormField(
      maxLength: 100,
      validator: (input) {
        if (input.length < 6) {
          return 'password very short';
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: true,
      style: style,
      onSaved: (input) => _password = input,
    );
    final direccionField = TextFormField(
      maxLength: 100,
      validator: (input) {
        if (input.isEmpty) {
          return 'provide an address';
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Address',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      obscureText: false,
      style: style,
      onSaved: (input) => _dir = input,
    );
    final localidadField = DropdownButton<String>(
      hint: Text("Localidad"),
      items: [
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
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text("$value"),
        );
      }).toList(),
      onChanged: (String changedValue) {
        setState(() {
          _localidad = changedValue;
        });
      },
      value: _localidad,
    );
    a = BaseView(
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
                        nombreField,
                        SizedBox(height: 10.0),
                        emailField,
                        SizedBox(height: 10.0),
                        passwordField,
                        SizedBox(height: 10.0),
                        telefonoField,
                        SizedBox(height: 10.0),
                        direccionField,
                        SizedBox(height: 10.0),
                        localidadField,
                        SizedBox(height: 10.0),
                        botonEnviar
                      ],
                    ),
                  )),
            )));
    return a;
  }

  Future<void> signUp() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        //FirebaseUser user= await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        if (_email.toString().contains("@uniandes.edu.co")) {
          var user = (await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _email, password: _password))
              .user;
          user.sendEmailVerification();
          DateTime nacimiento = DateTime(1);
          Timestamp fecha = Timestamp.fromDate(nacimiento);
          var usuario = {
            "nombre": _nombre,
            "correo": _email,
            "telefono": int.parse(_telefono),
            "direccion": _dir,
            "carros": [],
            "fecha_nacimiento": fecha,
            "latitud": null,
            "localidad": _localidad,
            "longitud": null,
            "key": "",
            "sexo": '',
            "universidad": "Los Andes"
          };

          Firestore.instance.runTransaction((Transaction tx) async {
            await users.add(usuario);
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          a.showError("Lo sentimos, necesita un correo institucional");
        }
      } catch (e) {
        a.showError(e.message);
      }
    }
  }
}
