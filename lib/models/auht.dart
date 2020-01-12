import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static Future<String> singIn(String _email, String _password) async {
    if (!_email.toString().contains("@uniandes.edu.co"))
      throw ("Lo sentimos, necesita un correo institucional");

    FirebaseUser user;
    try {
      user = (await auth.signInWithEmailAndPassword(
              email: _email, password: _password))
          .user;
    } catch (e) {
      throw ("usuario o contraseña no existe");
    }

    if (!user.isEmailVerified) throw ("Debes validar tu correo");

    _firebaseMessaging.requestNotificationPermissions();
    return _firebaseMessaging.getToken();
  }
}
