import 'package:alfred_tutorial_1/server.dart';
import 'package:alfred_tutorial_1/services/services.dart';
import 'package:get_it/get_it.dart';

main() async {
  GetIt.instance.registerSingleton(Services());
  final server = Server();

  await server.start();
}
