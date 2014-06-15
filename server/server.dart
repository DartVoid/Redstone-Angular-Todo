import 'dart:io';
import 'dart:async';

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:connection_pool/connection_pool.dart';
import 'package:di/di.dart';
import 'package:logging/logging.dart';

import 'package:client/client.dart' show Item;

// Setup application log
var logger = new Logger("todo");

/// Create a connection pool for MongoDB
class MongoDbPool extends ConnectionPool<Db> {
String uri;

MongoDbPool(String this.uri, int poolSize) : super(poolSize);

@override
void closeConnection(Db conn) {
  conn.close();
}

@override
Future<Db> openNewConnection() {
  var conn = new Db(uri);
  return conn.open().then((_) => conn);
}
}

/// Init database connection
@app.Interceptor(r'/.*')
dbInterceptor(MongoDbPool pool) {
  pool.getConnection().then((managedConnection) {
    app.request.attributes["conn"] = managedConnection.conn;
    app.chain.next(() {
      if (app.chain.error is ConnectionException) {
        pool.releaseConnection(managedConnection, markAsInvalid: true);
      } else {
        pool.releaseConnection(managedConnection);
      }
    });
  });
}

@app.Group("/todos")
class Todo {
  final String collectionName = "items";

  @app.Route('/list')
  list(@app.Attr() Db conn) {
    logger.info("List items");
    
    var itemsColl = conn.collection(collectionName);
    return itemsColl.find().toList().then((items) {
      logger.info("Found ${items.length} item(s)");
      return items;
    }).catchError((e) {
      logger.warning("Unable to find any items: $e");
      return [];
    });
  }

  @app.Route('/add', methods: const [app.POST])
  add(@app.Attr() Db conn, @app.Body(app.JSON) Map item) {
    logger.info("Add new item");

    // Parse item to make sure only objects of type "Item" is accepted 
    var newItem = new Item.fromJson(item);
    
    // Add item to database 
    var itemsColl = conn.collection(collectionName);
    return itemsColl.insert(newItem.toJson()).then((dbRes) {
      logger.info("Mongodb: $dbRes");
      return "ok";
    }).catchError((e) {
      logger.warning("Unable to insert new item: $e");
      return "error";
    });
  }

  @app.Route('/update', methods: const [app.POST])
  update(@app.Attr() Db conn, @app.Body(app.JSON) Map item) {
    // Parse item to make sure only objects of type "Item" is accepted 
    var updatedItem = new Item.fromJson(item);
    logger.info("Updating item ${updatedItem.id}");
    
    // Update item in database
    var itemsColl = conn.collection(collectionName);
    return itemsColl.update({"id": updatedItem.id}, updatedItem.toJson()).then((dbRes) {
      logger.info("Mongodb: ${dbRes}");
      return "ok";
    }).catchError((e) {
      logger.warning("Unable to update item: $e");
      return "error";
    }); 
  }

  @app.Route('/delete/:id', methods: const [app.DELETE])
  delete(@app.Attr() Db conn, String id) {
    logger.info("Deleting item $id");
    
    // Remove item from database 
    var itemsColl = conn.collection(collectionName);
    return itemsColl.remove({"id": id}).then((dbRes) {
      logger.info("Mongodb: $dbRes");
      return "ok";
    }).catchError((e) {
      logger.warning("Unable to update item: $e");
      return "error";
    });
  }

}

void main() {
  // Server port assignment
  var PORT = Platform.environment['PORT'];
  var appPort = PORT != null ? int.parse(PORT) : 8080;
  
  // Database endpoint assignment
  var MONGODB_URI = Platform.environment['MONGODB_URI'];  
  var appDB = MONGODB_URI != null ? MONGODB_URI : "mongodb://localhost/todo"; 
    
  // Set connection pool size
  var poolSize = 3;
  
  // Inject database connection pool
  app.addModule(new Module()
    ..bind(MongoDbPool, toValue: new MongoDbPool(appDB, poolSize)));

  // Setup server log
  app.setupConsoleLog();
  
  // Start server
  app.start(address: '127.0.0.1', port: appPort);
}

