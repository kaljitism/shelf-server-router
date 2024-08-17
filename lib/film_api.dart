import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class FilmAPI {
  final List data = jsonDecode(File('films.json').readAsStringSync());

  Router get router {
    final router = Router();

    router.get("/", (Request request) {
      return Response.ok(jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
    });

    router.get("/<id|[0-9]+>", (Request request, String id) {
      final parsedId = int.tryParse(id);
      final film = data.firstWhere((film) => film['id'] == parsedId,
          orElse: () => null);
      if (film != null) {
        return Response.ok(jsonEncode(film), headers: {
          'Content-Type': 'application/json'
        });
      } else {
        return Response.notFound("Film not found!");
      }
    });

    router.post('/', (Request request) async {
      final payload = await request.readAsString();
      data.add(jsonDecode(payload));
      return Response.ok(payload, headers: {
        'Content-Type': 'application/json'
      });
    });

    router.delete('/<id>', (Request request, String id) {
      final parsedId = int.tryParse(id);
      data.removeWhere((film) => film['id']
          == parsedId);
      return Response.ok("Deleted!");
    });
    
    return router;
  }
}
