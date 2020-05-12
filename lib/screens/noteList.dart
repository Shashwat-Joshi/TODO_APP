import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../note.dart';
import '../dataBaseHelper.dart';
import 'noteDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;
  List<Note> noteList;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AvatarGlow(
              endRadius: 30.0,
              child: IconButton(
                tooltip: "Add Todo",
                icon: Icon(Icons.add_comment),
                onPressed: () {
                  moveToNoteDetails(Note("", "", 2), "ADD TODO");
                },
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "TODO",
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFEC726F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 400.0,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 140.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "PLAN  YOUR",
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white,
                          fontSize: 35.0,
                        ),
                      ),
                      Text(
                        "  WORK",
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white,
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        "&",
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white,
                          fontSize: 35.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "WORK",
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white,
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "  YOUR  PLAN",
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.white,
                          fontSize: 35.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 600.0,
            height: 491.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(70.0)),
              color: Color(0xFFF5BCBA),
            ),
            child: noteList.length == 0
                ? Card(
                    color: Colors.white,
                    elevation: 4.0,
                    margin: EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(70.0),
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(70.0),
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AvatarGlow(
                              glowColor: Color(0xFFEC726F),
                              endRadius: 40.0,
                              child: GestureDetector(
                                child: Icon(
                                  Icons.add_box,
                                  color: Color(0xFFEC726F),
                                  size: 38.0,
                                ),
                                onTap: () {
                                  moveToNoteDetails(
                                      Note("", "", 2), "ADD TODO");
                                },
                              ),
                            ),
                            Text(
                              "Add Notes",
                              style: TextStyle(
                                color: Color(0xFFEC726F),
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: count,
                    itemBuilder: (context, position) => Container(
                      padding: EdgeInsets.all(20.0),
                      height: 300,
                      width: 400,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(70.0),
                            topLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        elevation: 7.0,
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(70.0),
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.white.withOpacity(0.60),
                                  BlendMode.dstIn),
                              fit: BoxFit.fill,
                              image: AssetImage("images/noteList.png"),
                            ),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Text(
                                "Task ${position + 1}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.green,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 40.0)),
                              ListTile(
                                leading: Icon(
                                  Icons.title,
                                  color: Colors.blue,
                                  size: 30.0,
                                ),
                                title: Text("Title"),
                                subtitle: Text(noteList[position].title),
                              ),
                              ListTile(
                                leading:
                                    Icon(Icons.date_range, color: Colors.pink),
                                title: Text(noteList[position].date),
                              ),
                              Padding(padding: EdgeInsets.only(top: 30.0)),
                              Center(
                                child: AvatarGlow(
                                  endRadius: 50.0,
                                  glowColor: Colors.deepPurple,
                                  child: Card(
                                    shape: CircleBorder(),
                                    elevation: 2.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        moveToNoteDetails(
                                            this.noteList[position],
                                            "EDIT TODO");
                                      },
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.open_in_new,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 30.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void moveToNoteDetails(Note note, String appBarTitle) async {
    bool result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => NoteDetails(note, appBarTitle),
      ),
    );
    if (result == true) {
      // TODO: Update NoteList
      updateListView();
    }
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((notelist) {
        setState(() {
          this.noteList = notelist;
          this.count = notelist.length;
        });
      });
    });
  }
}
