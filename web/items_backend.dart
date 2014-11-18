part of main;

// Backend class that communicates with the backend and hold the items list
@Injectable()
class ItemsBackend {
  BrowserClient _http = new BrowserClient();
  String _baseUrl;

  ItemsBackend() {
    // Initialize baseUrl (9090 for during development locally, otherwise use
    // standard port 80 for production, pub serve uses 8080)
    Uri uri = Uri.parse(window.location.href);
    var port = uri.port != 8080 ? 80 : 9090;
    _baseUrl = 'http://${uri.host}:${port}';
  }

  Future<List<Item>> getAll() {
    // Make request to get a list of all todo items
    return _http.get('${_baseUrl}/todos/list').then((res) {
      return decodeJson(res.body, Item);
    }).catchError((error) {
      print("Got error $error");
    });
  }

  Future add(Item item) {
    print("In backend.add");

    // Make request to add new item to database
    return _http.post("${_baseUrl}/todos/add", body: encodeJson(item), headers: {
        "content-type": "application/json"
    }).catchError((error) {
      print("Got error $error");
    });
  }

  Future update(Item item) {
    print("In backend.update");

    // Make request to update item
    return _http.put("${_baseUrl}/todos/update", body: encodeJson(item), headers: {
        "content-type": "application/json"
    }).catchError((error) {
      print("Got error $error");
    });
  }

  Future delete(Item item) {
    print("In backend.delete");

    // Make request to delete item
    return _http.delete("${_baseUrl}/todos/delete/${item.id}")
    .catchError((error) {
      print("Got error $error");
    });
  }
}