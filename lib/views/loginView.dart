import '../general/BaseView.dart';
import '../models/auht.dart';
import '../models/dataAccess.dart';
import '../models/streams/connectivity.dart';
import '../models/streams/streamPerfil.dart';
import '../viewModel/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:validators/validators.dart';

class LogginView extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => BaseView(
      scaffold: BaseScaffold(
          scaffoldState: _scaffoldState,
          appBar: AppBar(backgroundColor: Colors.black),
          body: LoginForm(onLoggin: singIn)));

  void singIn(BuildContext context, String email, String password) async {
    try {
      String tokenD = await Auth.singIn(email, password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return FutureBuilder(
            future: getProfile(email, password, tokenD),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PerfilStream(idPerfil: snapshot.data.id);
                return Home(profile: snapshot.data);
              } else {
                return CircularProgressIndicator();
              }
            });
      }));
    } catch (e) {
      String error = (e as String);
      BaseView.of(context).showError(error);
    }
  }
}

typedef OnLoggin(BuildContext context, String email, String password);

class LoginForm extends StatefulWidget {
  final OnLoggin onLoggin;

  LoginForm({@required this.onLoggin});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) => Form(
      key: _formkey,
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 160.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                TextFormField(
                  maxLength: 100,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.getInstance().setWidth(30),
                          vertical: ScreenUtil.getInstance().setHeight(30)),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                  obscureText: false,
                  style: TextStyle(fontSize: 20.0),
                  onSaved: (input) => _email = input,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  maxLength: 100,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Longer password please';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.getInstance().setWidth(30),
                          vertical: ScreenUtil.getInstance().setHeight(30)),
                      hintText: 'password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                  onSaved: (input) => _password = input,
                  obscureText: true,
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: ScreenUtil.getInstance().setHeight(90)),
                Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.black,
                    child: StreamBuilder(
                        stream: ConnectionStatus.getInstance().connectionChange,
                        builder: (BuildContext contexy,
                                AsyncSnapshot<bool> snapshot) =>
                            MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        ScreenUtil.getInstance().setWidth(30),
                                    vertical:
                                        ScreenUtil.getInstance().setHeight(30)),
                                onPressed: snapshot.hasData && snapshot.data
                                    ? () {
                                        final formState = _formkey.currentState;
                                        if (formState.validate()) {
                                          formState.save();
                                          widget.onLoggin(
                                              context, _email, _password);
                                        }
                                      }
                                    : null,
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0).copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )))),
                SizedBox(height: ScreenUtil.getInstance().setHeight(30)),
              ],
            ),
          )));
}
