import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetail {
  String id;
  String _description;
  String _date;
  String _startTime;
  String _endTime;
  String _speaker;
  bool _isFavorite;

  EventDetail(this.id, this._description, this._date,
      this._startTime, this._endTime, this._speaker, this._isFavorite);

  String get description => _description;
  String get date => _date;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get speaker => _speaker;
  bool get isFavorite => _isFavorite;

  EventDetail.fromMap(dynamic obj) {
    this.id = (obj as QueryDocumentSnapshot).id; //obj['id'];
    this._description = obj['description'];
    this._date = obj['date'];
    this._startTime = obj['start_time'];
    this._endTime = obj['end_time'];
    this._speaker = obj['speaker'];
    this._isFavorite = obj['is_favorite'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['description'] = _description;
    map['date'] = _date;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['speaker'] = _speaker;
    map['is_favorite'] = _isFavorite;

    return map;
  }

}
