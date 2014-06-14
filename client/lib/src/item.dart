part of client;

class Item {
  String id;
  String text = "";
  bool done = false;
  bool archived = false;
  
  static UuidBase uuid = new UuidBase();
  
  Item([this.text, this.done, this.archived, id]) {
    if(id == null) {
      this.id = uuid.v1();
    } else {
      this.id = id;
    }
  }

  bool get isEmpty {
    if(text == null) {
      return false;
    } else {
      return text.isEmpty;
    }
  }

  Item clone() => new Item(text, done, archived, id);

  void clear() {
    print("Inside clear()");
    text = '';
    done = false;
    archived = false;
  }
  
  Item.fromJson(Map json) {
    id = json["id"];
    text = json["text"];
    done = json["done"];
    archived = json["archived"];
  }
  
  Map toJson() {
    return {"id": id, "text": text, "done": done, "archived": archived};
  }
}

