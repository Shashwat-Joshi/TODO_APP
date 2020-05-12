import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../note.dart';
import '../dataBaseHelper.dart';
import 'package:intl/intl.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetails(this.note, this.appBarTitle);
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  static var _priorities = ["High", "Low"];
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            widget.appBarTitle,
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 27.0,
            ),
          ),
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.white12,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              moveToLastScreen();
            },
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.white12,
                icon: Icon(Icons.save),
                onPressed: () {
                  setState(() {
                    _save();
                  });
                },
              ),
            ),
          ],
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFFEC726F),
        body: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.fromLTRB(20.0, 105.0, 20.0, 20.0),
          child: Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: AssetImage("images/notes.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomLeft,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.85),
                  BlendMode.dstIn,
                ),
              ),
            ),
            child: Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 50.0)),
                    ListTile(
                      leading: Icon(
                        Icons.low_priority,
                        size: 30.0,
                        color: Color(0xFFEC726F),
                      ),
                      trailing: Text("(priority)"),
                      title: DropdownButton(
                        icon: Icon(Icons.arrow_drop_down),
                        elevation: 7,
                        items: _priorities.map((String dropDownItems) {
                          return DropdownMenuItem(
                            value: dropDownItems,
                            child: Text(
                              dropDownItems,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _savePriorityAsInt(value);
                          });
                        },
                        value: _getPriorityAsString(widget.note.priority),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 35.0)),

                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: Icon(
                          Icons.title,
                          size: 30.0,
                          color: Color(0xFFEC726F),
                        ),
                      ),
                      title: TextField(
                        controller: titleController,
                        onChanged: (value) {
                          updateTitle();
                        },
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 35.0)),

                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 23.0),
                        child: Icon(
                          Icons.description,
                          size: 30.0,
                          color: Color(0xFFEC726F),
                        ),
                      ),
                      title: TextField(
                        controller: descriptionController,
                        onChanged: (value) {
                          updateDescription();
                        },
                        decoration: InputDecoration(
                          labelText: "Details",
                        ),
                        minLines: 1,
                        maxLines: 10,
                        scrollPhysics: BouncingScrollPhysics(),
                      ),
                    ),
                    //
                    Padding(padding: EdgeInsets.only(top: 55.0)),
                    AvatarGlow(
                      child: ButtonTheme(
                        shape: CircleBorder(),
                        child: MaterialButton(
                          child: Icon(Icons.delete, color: Colors.pink),
                          onPressed: () {
                            _delete();
                          },
                        ),
                      ),
                      glowColor: Colors.pink,
                      endRadius: 30.0,
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateTitle() {
    widget.note.title = titleController.text;
  }

  void updateDescription() {
    widget.note.description = descriptionController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save() async {
    if (widget.note.title.length == 0) {
      _showAlertDialog('Status', 'Title can\'t be empty', true);
      return;
    }

    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    var result;

    if (widget.note.id == null) {
      result = await databaseHelper.insertNote(widget.note);
    } else {
      result = await databaseHelper.updateNote(widget.note);
    }

    moveToLastScreen();

    if (result != 0) {
      _showAlertDialog('Status', 'Note added successfully', false);
    } else {
      _showAlertDialog('Status', 'Error saving note', true);
    }
  }

  void _delete() async {
    if (widget.note.id == null) {
      _showAlertDialog('Status', 'First add a note', true);
      return;
    }
    var result;
    result = await databaseHelper.deleteNote(widget.note.id);

    moveToLastScreen();

    if (result != 0) {
      _showAlertDialog('Status', 'Note deleted Successfully', false);
    } else {
      _showAlertDialog('Status', 'Error deleting note', true);
    }
  }

  void _savePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        widget.note.priority = 1;
        break;
      case 'Low':
        widget.note.priority = 2;
        break;
    }
  }

  String _getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void _showAlertDialog(String title, String description, bool error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 7.0,
        title: Text(
          title,
          style: TextStyle(
            color: error ? Colors.red : Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          description,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
