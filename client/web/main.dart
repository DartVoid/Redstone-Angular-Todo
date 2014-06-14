import 'package:angular/application_factory.dart';
import 'package:di/di.dart';
import 'package:client/client.dart';

void main() {
  var module = new Module()
        ..bind(Todo)
        ..bind(ItemsBackend);

    applicationFactory().addModule(module).run();
}

