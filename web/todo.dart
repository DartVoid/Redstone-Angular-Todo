part of main;

@Injectable()
class Todo {
  Item newItem;
  List<Item> items = [];

  ItemsBackend _items;

  Todo(this._items) {
    newItem = new Item();

    // Get all todo items from server backend
    getItems();
  }

  bool get isEmpty => newItem.validate() != null;

  void getItems() {
    _items.getAll().then((items) => this.items = items);
  }

  // Add a new todo
  void add() {
    // Don't add empty todo's
    if (newItem.validate() != null) return;

    // Add new entry to list of items and save to backend
    _items.add(newItem).then((_) => getItems());

    // Recreate the input item so that it gets a new id (mapped to the UI)
    newItem = new Item();
  }

  // Delete todo
  void delete(Item item) {
    print("In delete: ${item}");

    // Send change to backend
    _items.delete(item).then((_) => getItems());
  }

  // Toogle done state for item
  void done(Item item) {
    print("In done: ${item}");

    // Toogle state
    item.done = !item.done;

    // Send change to backend
    _items.update(item);
  }

  void clear() {
    newItem = new Item();
  }

  String classFor(Item item) =>
    item.done ? "done" : "";

  int remaining() {
    return items.fold(0, (count, item) => count += item.done ? 0 : 1);
  }
}

