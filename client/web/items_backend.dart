part of main;

// Backend class that communicates with the backend and hold the items list  
@Injectable()
class ItemsBackend {
  final Http _http;
  List<Item> data = [];
  
  ItemsBackend(this._http);
  
  void getAll() {
    // Make request to get a list of all todo items
//    _http.get('http://${appname}.${username}.dartblob.com/todos').then((HttpResponse res) {
    _http.get('/todos/list').then((HttpResponse res) {
      
      print(res.data);
      
//      res.data.forEach((item) {
//        data.add(new Item.fromJson(item));
//      });
    }).catchError((error) {
      print("Got error $error");
    }); 
  }
  
  void add(Item item) { 
    print("In backend.add");
    
    // Add new item to list, instant change in UI 
    data.add(item);
    
    // Make request to add new item to database
//    _http.post("http://${appname}.${username}.dartblob.com/todos",
    _http.post("/todos/add", 
                JSON.encode(item)).then((HttpResponse res) {
      // If there were an error, remove it from the list 
      if(res.status != 200) {
        data.removeWhere((i) => i.id == item.id);
      }
    }).catchError((error) {
      print("Got error $error");
      
      // If there were an error, remove it from the list 
      data.removeWhere((i) => i.id == item.id);
    });
  }
  
  void update(int index) {
    print("In backend.update");
    
    // Make request to update archive property in database
//    _http.put("http://${appname}.${username}.dartblob.com/todos",
    _http.put("/todos/update", 
              JSON.encode(data[index])).then((HttpResponse res) {
      // If action was not successfull, reset item's state  
      if(res.status == 200) {
        print("Item has been updated");
      } else {
        print("There was an error updating the item");
      }
    }).catchError((error) {
      print("Got error $error");
    });
  }
  
  void delete(int index) {
    print("In backend.delete");
    
    // Save a copy of item in case action fails 
    var item = data[index];
    
    // Remove item instantly in UI 
    data.removeAt(index);
    
    // Make request to delete item 
//    _http.delete("http://${appname}.${username}.dartblob.com/todos/${item.id}").then((HttpResponse res) {
    _http.delete("/todos/delete/${item.id}").then((HttpResponse res) {
      // If action was not successfull, put back item into list again 
      if(res.status != 200) {
        data.insert(index, item);
      }
    }).catchError((error) {
      print("Got error $error");
      
      // If there was an error, put back the item into list again 
      data.insert(index, item);
    });
  }
}

