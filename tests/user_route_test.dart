import 'dart:convert';

import 'package:alfred_tutorial_1/server.dart';
import 'package:alfred_tutorial_1/services/database.dart';
import 'package:alfred_tutorial_1/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

main() {
  Server? server;

  setUp(() async {
    final db = await Db.create(
        'mongodb+srv://alfredtest:alfredtest@cluster0.9mrsc.mongodb.net/testdb?retryWrites=true&w=majority');
    GetIt.instance.registerSingleton(DatabaseService(db));
    await database.open();
    GetIt.instance.registerSingleton(Services());
    server = Server();
    await server!.start();
  });

  tearDown(() async {
    database.close();
    GetIt.instance.unregister<DatabaseService>();
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

  test('it should create an account', () async {
    final createResponse = await http
        .post(Uri.parse('http://localhost:3000/users/createAccount'), body: {
      "firstName": "Test 2",
      "lastName": "test 2 surname",
      "email": "test2@email.com",
      "password": "test2pass"
    });

    print(createResponse.body);
    expect(createResponse.statusCode, 200);
  });
}
