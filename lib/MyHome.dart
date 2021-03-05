import 'package:flutter/material.dart';
import 'package:notepade/AddNote.dart';
import 'package:notepade/Model/Photo.dart';
import 'package:notepade/SearchPage.dart';
import 'package:notepade/Model/DBhelper.dart';
import 'package:notepade/Model/Note.dart';
import 'package:flutter/foundation.dart';
import 'package:notepade/UpdateNote.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

String search;
String photo;
int photoId;

class _MyHomePageState extends State<MyHomePage> {
  DBhelper _dbHelper = DBhelper.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            tooltip: "Search",
            iconSize: 30,
            padding: EdgeInsets.all(20),
            onPressed: () {
              _showMaterialDialog(context);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _dbHelper.selectAll(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Note note = Note.fromMap(snapshot.data[index]);

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _dbHelper.deleteNote(note.noteId);
                      _dbHelper.deletePhoto(note.noteId);
                    });

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "the note of ${note.title} is delete",
                        style: TextStyle(fontSize: 18),
                      ),
                      duration: Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Undo',
                        textColor: Colors.green,
                        onPressed: () {
                          setState(() {
                            _dbHelper.insertNote(note);
                            getImageAfterDelete(note);

                          });
                        },
                      ),
                    ));
                  },
                  background: Container(color: Colors.purple),
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      leading: Icon(Icons.notes_rounded),
                      title: Text(note.title),
                      subtitle: Text("${note.time}" + "  " + "${note.date}"),
                      trailing: Icon(Icons.delete_sweep_sharp),
                      onTap: () {
                      getImage(note);

                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNote()))
              .then((value) {
            setState(() {});
          });
        },
        tooltip: 'Add Note',
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }

  _showMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              content: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Search here...'),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    search = value;
                  }
                },
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Search'),
                  color: Colors.purple,
                  onPressed: () {
                    if (search.isNotEmpty) {
                      setState(() {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) =>
                                    SearchPage(search: search)))
                            .then((value) {
                          search = "";
                        });
                      });
                    }
                  },
                )
              ],
            ));
  }

  getImage(Note note) async {
    List p = await _dbHelper.selectPhoto(note.noteId);

   if(p.isNotEmpty) {
     photo= p.asMap()[0]["photo"];
     photoId = p.asMap()[0]["photoId"];
     Navigator.of(context).push(MaterialPageRoute(
         builder: (context) => UpdateNote(note: note, photo: photo,photoId: photoId)));
   }else{
     Navigator.of(context).push(MaterialPageRoute(
         builder: (context) => UpdateNote(note: note)));

   }
  }
  getImageAfterDelete(Note note)async{
    List p = await _dbHelper.selectPhoto(note.noteId);
    if(p.isNotEmpty) {
      photo = p.asMap()[0]["photo"];
      photoId = p.asMap()[0]["photoId"];
      Photo ph = Photo(photo, note.noteId);
      _dbHelper.insertPhoto(ph);
    }
  }
}
