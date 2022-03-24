import 'dart:convert';

import 'package:alfred_tutorial_1/server.dart';
import 'package:alfred_tutorial_1/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

main() {
  Server? server;

  setUp(() async {
    GetIt.instance.registerSingleton(Services());
    server = Server();
    await server!.start();
  });

  tearDown(() async {
    GetIt.instance.unregister<Services>();
    if (server != null) {
      await server!.app.close();
    }
  });

  test('it should login a user', () async {
    final response = await http.post(
        Uri.parse('http://localhost:3000/users/login'),
        body: {'email': 'test@email.com', 'password': 'password'});
    final data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    expect(data['token'] != null, true);
  });

  test('it should get the current user', () async {
    final loginResponse = await http.post(
        Uri.parse('http://localhost:3000/users/login'),
        body: {'email': 'test@email.com', 'password': 'password'});
    final loginData = jsonDecode(loginResponse.body);
    final token = loginData['token'];
    final response = await http.get(
        Uri.parse('http://localhost:3000/users/currentUser'),
        headers: {'Authorization': 'Bearer $token'});
    print(response.body);
    expect(response.statusCode, 200);
  });
}
