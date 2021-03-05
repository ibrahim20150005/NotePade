class Note {
  int _noteId;
  String _title;
  String _content;
  String _date;
  String _time;

  // ignore: unnecessary_getters_setters
  set noteId(int noteId) {
    _noteId = noteId;
  }

  // ignore: unnecessary_getters_setters
  set title(String title) {
    _title = title;
  }

  // ignore: unnecessary_getters_setters
  set content(String content) {
    _content = content;
  }

  // ignore: unnecessary_getters_setters
  set date(String date) {
    _date = date;
  }

  // ignore: unnecessary_getters_setters
  set time(String time) {
    _time = time;
  }

  // ignore: unnecessary_getters_setters
  int get noteId {
    return _noteId;
  }

  // ignore: unnecessary_getters_setters
  String get title {
    return _title;
  }

  // ignore: unnecessary_getters_setters
  String get content {
    return _content;
  }

  // ignore: unnecessary_getters_setters
  String get date {
    return _date;
  }

  // ignore: unnecessary_getters_setters
  String get time {
    return _time;
  }

  Note(String title, String content, String date, String time) {
    this._title = title;
    this._content = content;
    this._date = date;
    this._time = time;
  }
  Note.fromMap(Map<String, dynamic> data) {
    _noteId = data["noteId"];
    _title = data["title"];
    _content = data["content"];
    _date = data["date"];
    _time = data["time"];
  }

  Map<String, dynamic> toMap() => {
        'noteId': _noteId,
        'title': _title,
        'content': _content,
        'date': _date,
        'time': _time
      };
}
