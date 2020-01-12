import '../models/streams/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BaseView extends InheritedWidget {
  static final ValueObservable<bool> _conectionStream =
      ConnectionStatus.getInstance().connectionChange;
  final BaseScaffold scaffold;

  BaseView({@required this.scaffold}) : super(child: scaffold);

  @override
  bool updateShouldNotify(BaseView oldWidget) => scaffold != oldWidget.scaffold;

  void showError(String mensage, {int seconds = 3}) {
    scaffold.showErrorInSnak(mensage, seconds);
  }

  static BaseView of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BaseView) as BaseView);
  }
}

class BaseScaffold extends Scaffold {
  final String internetMensaje;
  final GlobalKey<ScaffoldState> scaffoldState;
  final ValueObservable<bool> _conectionStream =
      ConnectionStatus.getInstance().connectionChange;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snak;
  String currenErrorMensage;

  BaseScaffold({
    this.scaffoldState,
    this.internetMensaje='No hay conexión a internet',
    appBar,
    body,
    floatingActionButton,
    floatingActionButtonLocation,
    floatingActionButtonAnimator,
    persistentFooterButtons,
    drawer,
    endDrawer,
    bottomNavigationBar,
    bottomSheet,
    backgroundColor,
    resizeToAvoidBottomPadding,
    resizeToAvoidBottomInset,
    primary = true,
    drawerDragStartBehavior = DragStartBehavior.start,
    extendBody = false,
    extendBodyBehindAppBar = false,
    drawerScrimColor,
    drawerEdgeDragWidth,
  }) : super(
          key: scaffoldState,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          primary: primary,
          drawerDragStartBehavior: drawerDragStartBehavior,
          extendBody: extendBody,
          drawerScrimColor: drawerScrimColor,
          drawerEdgeDragWidth: drawerEdgeDragWidth,
        ) {
    _conectionStream.listen((bool hasConnection) {
      if (!hasConnection) {
        _noConection();
      } else {
        if (scaffoldState.currentState != null) {
          scaffoldState.currentState.removeCurrentSnackBar();
        }
      }
    });
  }

  void showErrorInSnak(String mensage, int seconds) {
    if (mensage != currenErrorMensage) {
      currenErrorMensage = mensage;

      scaffoldState.currentState.removeCurrentSnackBar();

      SnackBar snackBar = SnackBar(
          content: Text(mensage), duration: Duration(seconds: seconds));
      scaffoldState.currentState
          .showSnackBar(snackBar)
          .closed
          .then((SnackBarClosedReason reason) {
        currenErrorMensage = null;
      });
    }
  }

  void _noConection() {
    print(scaffoldState);
    try {
      scaffoldState.currentState.removeCurrentSnackBar();
    } catch (e) {}
    SnackBar snackBar = SnackBar(
        content: Text(internetMensaje),
        duration: Duration(days: 1));
    scaffoldState.currentState.showSnackBar(snackBar);
    currenErrorMensage = null;
  }
}
