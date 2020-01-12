import 'car.dart';

class Descripcion {
  Descripcion({this.comentario, this.carro});
  String comentario;
  Car carro;

  Descripcion.cargarJson(Map<dynamic, dynamic> json)
      : comentario = json['comentario'],
        carro = Car.cargarJson(json['carro']);
}
