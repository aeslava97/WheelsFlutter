
import '../models/DAOS/DAOS.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MyMap extends StatelessWidget {
  MyMap(Key key,
      {this.centerLat: 4.603,
      this.centerLon: -74.0674,
      this.positions,
      this.controller})
      : super(key: key);
  final double centerLat;
  final double centerLon;
  final List<Position> positions;
  final MyMapController controller;

//INICIO DE https://stackoverflow.com/questions/6048975/google-maps-v3-how-to-calculate-the-zoom-level-for-a-given-bounds
  double _latRad(double lat) {
    var sino = sin(lat * pi / 180);
    var radX2 = log((1 + sino) / (1 - sino)) / 2;
    return max(min(radX2, pi), -pi) / 2;
  }

  double _zoom(double mapPx, double worldPx, double fraction) {
    return log(mapPx / worldPx / fraction) / ln2;
  }

  double _getZoom(double maxlng, double minlng, double maxlat, double minlat,
      BuildContext context) {
    double maxZoom = 19;
    var latFraction = (_latRad(maxlat) - _latRad(minlat)) / pi;
    var lngDiff = maxlng - minlng;
    var lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;
    var latZoom =
        _zoom(MediaQuery.of(context).size.height * 0.7, 256, latFraction);
    var lngZoom = _zoom(MediaQuery.of(context).size.width, 256, lngFraction);
    return min(min(latZoom, lngZoom), maxZoom);
  }

//FINAL DE https://stackoverflow.com/questions/6048975/google-maps-v3-how-to-calculate-the-zoom-level-for-a-given-bounds
//metodo para sacar el centro
  LatLng getCenter() {
    var lat = centerLat;
    var lng = centerLon;
    if (positions.isNotEmpty) {
      lat = 0;
      lng = 0;
      for (Position pos in positions) {
        lat += pos.lat;
        lng += pos.lng;
      }

      lat /= positions.length;
      lng /= positions.length;
    }
    return LatLng(lat, lng);
  }

// se calculan los bordes y con eso el zoom, el 0.5 es un machetazo, el 15 es arbitrario
  double getZoom(BuildContext context) {
    if (positions.isNotEmpty) {
      double maxlng = positions.reduce((a, b) => (a.lng > b.lng) ? a : b).lng;
      double minlng = positions.reduce((a, b) => (a.lng < b.lng) ? a : b).lng;
      double maxlat = positions.reduce((a, b) => (a.lat > b.lat) ? a : b).lat;
      double minlat = positions.reduce((a, b) => (a.lat < b.lat) ? a : b).lat;
      return _getZoom(maxlng, minlng, maxlat, minlat, context) - 0.5;
    } else
      return 15;
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) controller.onMapAct(getCenter());
    return GoogleMap(
        myLocationEnabled: true,
        markers: Set<Marker>.of(positions
            .map((Position pos) => Marker(
                markerId: MarkerId('${pos.lat}-${pos.lng}'),
                position: LatLng(pos.lat, pos.lng)))
            .toList()),
        initialCameraPosition:
            CameraPosition(target: getCenter(), zoom: getZoom(context)),
        onCameraMove: (CameraPosition position) {
          if (controller != null) controller.onMapAct(position.target);
        });
  }
}

class MyMapController {
  double centerMarkerlat, centerMarkerLng;
  void onMapAct(LatLng position) {
    centerMarkerlat = position.latitude;
    centerMarkerLng = position.longitude;
  }
}
