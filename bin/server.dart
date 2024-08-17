import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_server_router/film_api.dart';

void main(List<String> args) async {
  final List data = jsonDecode(File('films.json').readAsStringSync());
  final app = Router();

  app.mount('/films/', FilmAPI().router.call);
  
  app.get('/<name|.*>', (Request request, String name) {
    final param = name.isNotEmpty ? name : "world";
    return Response.ok("hello, $param\n");
  });

  await serve(app.call, 'localhost', 8080);
}
