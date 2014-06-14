part of client;

@Controller(
    selector: '[todo-controller]',
    publishAs: 'todo')
class Todo {
  Item newItem;
  ItemsBackend _items;

  Todo(this._items) {
    newItem = new Item();
    newItem.clear();
    
    // Get all todo items from server backend 
    _items.getAll();
  }
  
  // Return list of items  
  List<Item> get items => _items.data;
  
  // Add a new todo 
  void add() {
    // Don't add empty todo's
    if (newItem.isEmpty) return;

    // Add new entry to list of items and save to backend 
    _items.add(newItem.clone());
    
    // Recrete the input item so that it gets a new id (mapped to the UI) 
    newItem = new Item();
    
    // Run clear to make sure fields are reset (Bug in Angular? Fields becomes
    // null even if they are set to default values in the class so we need to
    // run clear on a new object...)
    newItem.clear();
  }

  // Delete todo 
  void delete(int index) {
    print("In delete: ${_items.data[index]}");
    
    // Send change to backend 
    _items.delete(index);
  }
  
  // Toogle archive state for item  
  void archive(int index) {
    print("In archive: ${_items.data[index]}");
    
    // Toogle state 
    _items.data[index].archived = ! _items.data[index].archived;
    
    // Send change to backend 
    _items.update(index);
  }

  // Toogle done state for item 
  void done(int index) {
    print("In done: ${_items.data[index]}");
    
    // Toogle state 
    _items.data[index].done = ! _items.data[index].done;
    
    // Send change to backend 
    _items.update(index); 
  }
  
  void markAllDone() {
    _items.data.forEach((item) => item.done = true);
  }

  void archiveDone() {
    _items.data.removeWhere((item) => item.done);
  }

  String classFor(Item item) {
    if(item.done == true) {
      return 'done';
    } else {
      return '';
    }
  }
  
  int remaining() {
    return _items.data.fold(0, (count, item) => count += item.done ? 0 : 1);
  }
}

