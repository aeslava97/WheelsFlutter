//Permisos de la app
import 'package:permission_handler/permission_handler.dart';

 class PermissionService{

  PermissionService();
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  /// Requests the users permission to read their location when the app is in use
  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    bool granted=  await _requestPermission(PermissionGroup.locationWhenInUse);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> hasLocalPermission() async {
    return hasPermission(PermissionGroup.locationWhenInUse);
  }
  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }
}