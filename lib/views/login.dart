import '../views/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'loginView.dart';

class Login extends StatefulWidget {
  const Login();

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _email, _password;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'))),
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil.getInstance().setWidth(30),
                vertical: ScreenUtil.getInstance().setHeight(30)),
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil.getInstance().setHeight(900)),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                      child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil.getInstance().setWidth(40),
                              vertical: ScreenUtil.getInstance().setHeight(40)),
                          onPressed: () {
                            createLoginForm(context);
                          },
                          child: Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    const SizedBox(height: 15),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.black,
                      child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil.getInstance().setWidth(30),
                              vertical: ScreenUtil.getInstance().setHeight(30)),
                          onPressed: () {
                            createSingUpForm();
                          },
                          child: Text(
                            'REGISTER',
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ]),
            ),
          ),
        ));
  }

  createLoginForm(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => LogginView());
  }

  createSingUpForm() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Signup(), fullscreenDialog: true));
  }
}
