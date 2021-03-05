class Photo {
  int _photoId;
  String _photo;
  int _noteId;

  // ignore: unnecessary_getters_setters
  set photoId(int photoId) {
    _photoId = photoId;
  }

  Photo(String photo, int noteId) {
    this._photo = photo;
    this._noteId = noteId;
  }
  // ignore: unnecessary_getters_setters
  set photo(String photo) {
    _photo = photo;
  }

  // ignore: unnecessary_getters_setters
  set noteId(int noteId) {
    _noteId = noteId;
  }

  // ignore: unnecessary_getters_setters
  int get photoId {
    return _photoId;
  }

  // ignore: unnecessary_getters_setters
  String get photo {
    return _photo;
  }

  // ignore: unnecessary_getters_setters
  int get noteId {
    return _noteId;
  }

  Photo.fromMap(Map<String, dynamic> data) {
    _photoId = data["photoId"];
    _photo = data["photo"];
    _noteId = data["noteId"];
  }
  Map<String, dynamic> toMap() =>
      {'photoId': _photoId, 'photo': _photo, 'noteId': _noteId};
}
