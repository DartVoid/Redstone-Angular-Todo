library main;

import 'dart:async';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:di/di.dart';
import 'package:client/client.dart';

part 'todo.dart';
part 'items_backend.dart';

void main() {
  
  bootstrapMapper();
  
  var module = new Module()
        ..bind(Todo)
        ..bind(ItemsBackend);

  applicationFactory().addModule(module).run();
}

