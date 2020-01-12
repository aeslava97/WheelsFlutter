

import '../views/createWheels/createWheels.dart';

import '../models/DAOS/DAOS.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateWheels extends StatefulWidget {
  CreateWheels({@required this.wheelsDir, @required this.profile});
  final WheelsDirecion wheelsDir;
  final Profile profile;

  @override
  State<StatefulWidget> createState() {
    return StateCreateWheels();
  }
}