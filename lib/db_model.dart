import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class DBModel<T> {
  @JsonKey(name: '_id', includeIfNull: false)
  dynamic id;

  @JsonKey(ignore: true)
  DbCollection collection;

  DBModel(this.collection, {this.id});

  Future<Map<String, Object?>?> save() async {
    if (id != null) {
      final result =
          await collection.updateOne({'_id': id}, toJson(), upsert: true);
      return result.document;
    } else {
      final payload = toJson();
      final result = await collection.insertOne(payload);
      final document = result.document;
      if (document != null) {
        id = result.document!['_id'];
      }
      return result.document;
    }
  }

  Future<List<T>> find([dynamic query]) async {
    final data = await collection.find(query).toList();
    return data.map<T>((item) => fromJson(item)).toList();
  }

  Stream<T> findStream([dynamic query]) async* {
    await for (var item in collection.find(query)) {
      yield fromJson(item);
    }
  }

  Future<T?> findOne([dynamic query]) async {
    final data = await collection.findOne(query);
    if (data != null) {
      if (data["\$err"] == null) {
        return fromJson(data);
      } else {
        throw Exception(data["\$err"]);
      }
    } else {
      return null;
    }
  }

  Future<T?> byId(dynamic id) {
    return findOne({"_id": id});
  }

  Future<void> delete() async {
    await collection.remove({"_id": id});
    return;
  }

  // ignore: missing_return
  Map<String, dynamic> toJson();

  // ignore: missing_return
  T fromJson(Map<String, dynamic> json);
}
