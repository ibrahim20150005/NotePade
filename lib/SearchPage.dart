import 'package:flutter/material.dart';
import 'package:notepade/AddNote.dart';
import 'package:notepade/Model/DBhelper.dart';
import 'package:notepade/Model/Note.dart';
import 'package:notepade/UpdateNote.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.search}) : super(key: key);
  final String search;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DBhelper _dbHelper = DBhelper.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" the Result"),
      ),
      body: FutureBuilder(
        future: _dbHelper.search(widget.search.toString()),
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
                    });

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(note.title),
                      duration: Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Undo',
                        textColor: Colors.green,
                        onPressed: () {
                          setState(() {
                            _dbHelper.insertNote(note);
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateNote(note: note)));
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
}
