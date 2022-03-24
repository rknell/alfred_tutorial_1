import 'dart:io';

import 'package:alfred_tutorial_1/server.dart';
import 'package:alfred_tutorial_1/services/database.dart';
import 'package:alfred_tutorial_1/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() async {
  final db = await Db.create(
      'mongodb+srv://alfredtest:alfredtest@cluster0.9mrsc.mongodb.net/alfredtest?retryWrites=true&w=majority');

  GetIt.instance.registerSingleton(DatabaseService(db));
  GetIt.instance.registerSingleton<Services>(Services());

  await database.open();

  final server = Server();
  final envPort = Platform.environment['PORT'];
  await server.start(port: int.tryParse(envPort ?? '3000') ?? 3000);
}
