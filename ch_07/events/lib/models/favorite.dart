import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  String _id;
  String _eventId;
  String _userId;
  Favorite(this._id, this._eventId, this._userId);

  String get eventId => _eventId;
  String get id => _id;

  Favorite.map(DocumentSnapshot document) {
    this._id = document.id;
    this._eventId = document.data()['eventId'];
    this._userId = document.data()['userId'];
  }

  Map<String, dynamic> toMap() {
    Map map = Map<String, dynamic>();
    if (_id!= null) {
      map['id'] = _id;
    }
    map['eventId'] = _eventId;
    map['userId'] = _userId;
    return map;
  }

}
