part of client;

class Item extends Schema {
  
  @Id()
  String id;
  
  @Field()
  @NotEmpty()
  String text;
  
  @Field()
  bool done;
  
  Item([this.id, this.text = "", this.done = false]);
  
  String toString() => "Item($id, $text, $done)";
  
}

