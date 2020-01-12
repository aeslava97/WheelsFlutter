import '../views/createCar/createCar.dart';
import '../models/DAOS/DAOS.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateCar extends StatefulWidget{
  const CreateCar(this.perfil, this.wheels, this.crearWheels);
  final Profile perfil;
  final WheelsDirecion wheels;
  final bool crearWheels;
  @override
  State<StatefulWidget> createState() => CreateCarState();
}