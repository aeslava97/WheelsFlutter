import '../views/confirmWheels/confirmWheels.dart';
import '../models/DAOS/DAOS.dart';
import 'package:flutter/material.dart';

class ConfirmWheels extends StatefulWidget {
  ConfirmWheels({@required this.wheels, @required this.perfil});
  final Wheels wheels;
  final Profile perfil;

  @override
  State<StatefulWidget> createState() {
    return StateConfirmWheels();
  }
}