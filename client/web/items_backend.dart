part of main;

// Backend class that communicates with the backend and hold the items list  
@Injectable()
class ItemsBackend {
  final Http _http;
  
  ItemsBackend(this._http);
  
  Future<List<Item>> getAll() {
    // Make request to get a list of all todo items
    return _http.get('/todos/list').then((HttpResponse res) {
      return decode(res.data, Item);
    }).catchError((error) {
      print("Got error $error");
    }); 
  }
  
  Future add(Item item) { 
    print("In backend.add");
    
    // Make request to add new item to database
    return _http.post("/todos/add", 
                JSON.encode(encode(item)))
      .catchError((error) {
        print("Got error $error");
      });
  }
  
  Future update(Item item) {
    print("In backend.update");
    
    // Make request to update item
    return _http.put("/todos/update", 
              JSON.encode(encode(item)))
      .catchError((error) {
        print("Got error $error");
      });
  }
  
  Future delete(Item item) {
    print("In backend.delete");
    
    // Make request to delete item 
    return _http.delete("/todos/delete/${item.id}")
      .catchError((error) {
        print("Got error $error");
      });
  }
}

