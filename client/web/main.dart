library main;

import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:di/di.dart';
import 'package:client/client.dart';

part 'todo.dart';
part 'items_backend.dart';

void main() {
  var module = new Module()
        ..bind(Todo)
        ..bind(ItemsBackend);

    applicationFactory().addModule(module).run();
}

