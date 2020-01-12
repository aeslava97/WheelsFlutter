import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notificacion extends StatelessWidget {

  
  Widget build (BuildContext context){
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final arg = ModalRoute.of(context).settings.arguments;
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);

  final botonAceptar = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
           Navigator.pop(context);
          },
          child: Text(
            'Aceptar',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final labelInfo= Material(

      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: Text(
            arg,
            textAlign: TextAlign.center,
            style: style.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      appBar: AppBar( 
      title: Text("Notificación"),
      backgroundColor: Colors.black,
      centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    labelInfo,
                    SizedBox(height: 10.0),
                    botonAceptar
                  ],
                ),
              ))

      ),
    );
  }

}
