class Car {
  Car({this.placa, this.modelo, this.color});
  String placa;
  String modelo;
  String color;

  

  Car.cargarJson(Map<dynamic,dynamic> json)
      : placa = json['placa'],
        modelo = json['modelo'],
        color = json['color'];
}
