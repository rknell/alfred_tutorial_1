import 'package:alfred/alfred.dart';
import 'package:alfred_tutorial_1/middleware.dart';
import 'package:alfred_tutorial_1/routes/users_route.dart';

class Server {
  final app = Alfred();

  Future start({int port = 3000}) async {
    app.get('/users/currentUser', UsersRoute.currentUser,
        middleware: [Middleware.isAuthenticated]);
    app.post('/users/login', UsersRoute.login);
    app.post('/users/createAccount', UsersRoute.createAccount);
    app.get('/status', (req, res) => 'Server Online');

    await app.listen(port);
  }
}
