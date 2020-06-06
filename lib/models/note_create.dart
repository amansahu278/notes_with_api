import 'package:flutter/foundation.dart';

class NoteCreate {
  String noteTitle;
  String noteContent;

  NoteCreate({
    @required this.noteTitle,
    @required this.noteContent
  });

  Map<String, dynamic> toJson(){
    return {
      'noteTitle' : this.noteTitle,
      'noteContent' : this.noteContent
    };
  }
}