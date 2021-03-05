
import 'package:flutter/material.dart';
import 'package:notepade/Model/DBhelper.dart';
import 'package:notepade/Model/Note.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepade/Model/Photo.dart';
import 'package:notepade/Model/Utility.dart';

class UpdateNote extends StatefulWidget {
  UpdateNote({Key key, this.note,this.photo,this.photoId}) : super(key: key);

  final Note note;
   String photo;
   final int photoId;
  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  TextEditingController titleControl = TextEditingController();
  TextEditingController contentControl = TextEditingController();

  DBhelper _dbHelper = DBhelper.getInstance();
  bool isCreate = false;
  String imgString;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();

    titleControl.text = widget.note.title;
    contentControl.text = widget.note.content;
  }

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
        title: Text("Update Note"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
            tooltip: "create",
            onPressed: () async {
              if (titleControl.text.isNotEmpty) {
                var now = DateTime.now();

                widget.note.title = titleControl.text;
                widget.note.content = contentControl.text;
                widget.note.time = "${now.hour}:${now.minute}";
                widget.note.date = "${now.day}/${now.month}/${now.year}";

                await _dbHelper.updateNote(widget.note);

                if(widget.photo==null&&imgString==null){
                  _dbHelper.deletePhoto(widget.photoId);
                }
                else if  (imgString != null) {

                  Photo photo = Photo(imgString, widget.note.noteId);
                  photo.photoId=widget.photoId;

                  if(photo.photoId==null){
                    _dbHelper.insertPhoto(photo);

                  }else{


                  _dbHelper.updatePhoto(photo);}
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
                child: imgString == null?widget.photo==null
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : Stack(
                  children: [
                    Utility.imageFromBase64String(widget.photo),
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
                              widget.photo=null;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ):Stack(
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
                                    widget.photo=null;
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
                maxLines: 33,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.purple,
        style: TabStyle.flip,
        items: [
          TabItem(icon: Icons.image, title: "Gallery "),
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
