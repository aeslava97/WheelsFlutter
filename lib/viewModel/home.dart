
import '../general/BaseControler.dart';
import '../models/DAOS/DAOS.dart';
import 'package:flutter/widgets.dart';
import '../views/home/home.dart';
enum VarsHomeTest { EsConductor, Direccion }

class Home extends StatefulWidget {
  final Controller<VarsHomeTest> controller =  Controller()
    ..add<bool>(VarsHomeTest.EsConductor, false)
    ..add<WheelsDirecion>(VarsHomeTest.Direccion, WheelsDirecion.uni_casa);

  Home({@required this.profile});
  final Profile profile;

  @override
  State<StatefulWidget> createState() => HomeState();

}



class WheelView extends StatefulWidget {
  const WheelView({@required this.wheels, @required this.profile});
  final Wheels wheels;
  final Profile profile;

  @override
  State<StatefulWidget> createState() {
    return StateWheelView();
  }
}