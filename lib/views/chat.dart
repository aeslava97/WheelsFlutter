import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ej/general/BaseView.dart';
import '../models/streams/streamsChat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/DAOS/chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatView extends StatelessWidget {
  ChatView({@required this.nombre, this.id});
  String nombre;
  TextEditingController _controller = TextEditingController();
  bool clickeado = false;
  String id;
  static final GlobalKey<ScaffoldState> _scaffoldkey =
      new GlobalKey<ScaffoldState>();

  String getHora(Timestamp ts) {
    DateTime a = ts.toDate();
    TimeOfDay tod = TimeOfDay(hour: a.hour, minute: a.minute);
    return "${tod.hour}:${tod.minute}";
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return BaseScaffold(
      scaffoldState: _scaffoldkey,
      internetMensaje: "No hay conexión a internet, los mensajes se enviarán cuando vuelva el internet",
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
          StreamBuilder(
              stream: ChatStream().chat,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
                if (snapshot.hasData) {
                  return Flexible(
                      child: ListView(
                          children: snapshot.data.map((Chat data) {
                    if (data.idEmisor.documentID == id) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.symmetric(
                                  vertical:
                                      ScreenUtil.getInstance().setHeight(15)),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      ScreenUtil.getInstance().setWidth(20)),
                              decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    data.text,
                                  ),
                                  Text(
                                    getHora(data.fecha),
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.getInstance().setSp(25),
                                        color: Colors.black38),
                                  )
                                ],
                              ))
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(data.nombre),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  vertical:
                                      ScreenUtil.getInstance().setHeight(15)),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      ScreenUtil.getInstance().setWidth(20)),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    data.text,
                                  ),
                                  Text(
                                    getHora(data.fecha),
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.getInstance().setSp(25),
                                        color: Colors.black38),
                                  )
                                ],
                              ))
                        ],
                      );
                    }
                  }).toList()));
                } else {
                  return CircularProgressIndicator();
                }
              }),
          Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                      controller: _controller,
                      maxLength: 1000,
                      onSubmitted: (String va) {
                        if (va.isNotEmpty) {
                          _controller.text = "";
                          ChatStream().add(Chat(
                              idPerfil: id,
                              nombre: nombre,
                              text: va,
                              fecha: Timestamp.fromDate(DateTime.now())));
                        }
                      })),
              FlatButton(
                  color: Colors.white,
                  child: Icon(
                    Icons.send,
                  ),
                  shape: CircleBorder(side: BorderSide(width: 1)),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      var va = _controller.text;
                      _controller.text = "";
                      ChatStream().add(Chat(
                          idPerfil: id,
                          nombre: nombre,
                          text: va,
                          fecha: Timestamp.fromDate(DateTime.now())));
                    }
                  })
            ],
          )
        ],
      ),
    );
  }
}
