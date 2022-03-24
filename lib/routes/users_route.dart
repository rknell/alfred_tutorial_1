import 'package:alfred/alfred.dart';
import 'package:alfred_tutorial_1/classes/user.dart';
import 'package:alfred_tutorial_1/services/services.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:dbcrypt/dbcrypt.dart';

class UsersRoute {
  static currentUser(HttpRequest req, HttpResponse res) async {
    final userToken = req.store.get('token') as JWT?;
    if (userToken != null) {
      final data = userToken.getClaim('data') as Map;
      final userEmail = data['email'];
      final foundUser = await services.users.findUserByEmail(email: userEmail);
      if (foundUser != null) {
        return foundUser;
      } else {
        throw AlfredException(401, {'message': 'user not found'});
      }
    }
  }

  static login(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final user = await services.users.findUserByEmail(email: body['email']);

    if (user == null || user.password == null) {
      throw AlfredException(401, {'message': 'Invalid user'});
    }

    try {
      final isCorrect = DBCrypt().checkpw(body['password'], user.password!);

      if (isCorrect == false) {
        throw AlfredException(401, {'message': 'Invalid password'});
      }

      var token = JWTBuilder()
        ..issuer = 'https://api.alfreddemo.com'
        ..expiresAt = new DateTime.now().add(new Duration(hours: 3))
        ..setClaim('data', {'email': user.email})
        ..getToken();

      var signedToken = token.getSignedToken(services.jwtSigner);

      return {'token': signedToken.toString()};
    } catch (e) {
      print(e);
      throw AlfredException(500, {'message': 'Unknown error occurred'});
    }
  }

  static createAccount(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final newUser = User.fromJson(body)..setPassword(body['password']);
    await newUser.save();
    return newUser;
  }
}
