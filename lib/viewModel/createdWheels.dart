import '../models/DAOS/DAOS.dart';
import '../views/createdWheels/createdWheels.dart';
import 'package:flutter/material.dart';


class CreatedWheels extends StatefulWidget {
  CreatedWheels(
      {@required this.profileConductor,
      @required this.profileUsuario,
      @required this.wheels});
  final Profile profileUsuario;
  final Profile profileConductor;
  final Wheels wheels;

  @override
  State<StatefulWidget> createState() {
    return StateCreatedWheels();
  }
}