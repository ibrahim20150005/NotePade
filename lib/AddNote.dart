import 'package:flutter/material.dart';
import 'package:notepade/Model/DBhelper.dart';
import 'package:notepade/Model/Note.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepade/Model/Photo.dart';
import 'package:notepade/Model/Utility.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DBhelper _dbHelper = DBhelper.getInstance();
  final titleControl = TextEditingController();
  final contentControl = TextEditingController();
  bool isCreate = false;
  String imgString;
  pickImageFromGallery(ImageSource source) {
    ImagePicker.pickImage(source: source).then((imgFile) {
      setState(() {
        imgString = Utility.base64String(imgFile.readAsBytesSync());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Note"),
        actions: <Widget>[
          IconButton(
            icon: isCreate == true
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  )
                : Icon(
                    Icons.check,
                    color: Colors.grey,
                    size: 30,
                  ),
            tooltip: "create",
            onPressed: () async {
              if (titleControl.text.isNotEmpty) {
                var now = DateTime.now();
                Note note = Note(
                    titleControl.text,
                    contentControl.text,
                    "${now.day}/${now.month}/${now.year}",
                    "${now.hour}:${now.minute}");
                final noteId = await _dbHelper.insertNote(note);

                if (imgString != null) {

                  Photo photo = Photo(imgString.toString(), noteId);
                  _dbHelper.insertPhoto(photo);
                }
                Navigator.of(context).pop();
              }
            },
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter a title'),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isCreate = true;
                    });
                  } else {
                    setState(() {
                      isCreate = false;
                    });
                  }
                },
                controller: titleControl,
              ),
              Container(
                child: imgString == null
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : Stack(
                        children: [
                          Utility.imageFromBase64String(imgString),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    imgString = null;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
              ),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Enter a content',
                ),
                controller: contentControl,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.purple,
        style: TabStyle.flip,
        items: [
          TabItem(icon: Icons.image, title: "Gallary"),
          TabItem(icon: Icons.camera_alt, title: "Camera"),
        ],
        initialActiveIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            pickImageFromGallery(ImageSource.gallery);
          } else {
            pickImageFromGallery(ImageSource.camera);
          }
        },
      ),
    );
  }
}
