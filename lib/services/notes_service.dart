import 'dart:convert';
import 'dart:async';
import 'package:noteswithapi/models/api_response.dart';
import 'package:noteswithapi/models/note.dart';
import 'package:noteswithapi/models/note_create.dart';
import 'package:noteswithapi/models/notes_for_list.dart';
import 'package:http/http.dart' as http;

class NotesService {

  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {
    'apiKey': '8a96b617-2032-4dca-8d27-0f59ef735da0',
    'Content-Type' : 'application/json'
  };

  Future<APIResponse<List<NoteForList>>> getNotesList() {
    return http.get(API + "/notes", headers: headers)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        final notes = <NoteForList>[];
        for (var item in jsonData) {
          notes.add(NoteForList.fromJson(item));
        }
        return APIResponse<List<NoteForList>>(data: notes);
      }else{
        return APIResponse<List<NoteForList>>(data: null, errorMessage: "${value.statusCode} ${json.decode(value.body)['title']}", error: true);
      }
    }).catchError((_)=> APIResponse<List<NoteForList>>(data: null, errorMessage: 'An error has occurred',error: true));
  }

  Future<APIResponse<Note>> getNote(String noteID){
    return http.get(API+'/notes/'+noteID, headers: headers)
        .then((value){
          if(value.statusCode == 200){
            final jsonData = json.decode(value.body);
            final note = Note.fromJson(jsonData);
            return APIResponse<Note>(data: note);
          } else {
            return APIResponse<Note>(data: null, error: true, errorMessage: "${value.statusCode} ${json.decode(value.body)['title']}");
          }
    }).catchError((_)=> APIResponse<Note>(data: null, errorMessage: 'An error has occurred',error: true));
  }

  Future<APIResponse<bool>> createNote(NoteCreate note){
    return http.post(API+'/notes', headers: headers, body: json.encode(note.toJson()))
    .then((value) {
      print(value.statusCode);
      if(value.statusCode == 201){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: null, error: true, errorMessage: "${value.statusCode} ${json.decode(value.body)['title']}");
    }).catchError((_) => APIResponse<bool>(data: null, error: true, errorMessage: "An error has occured"));
  }

  Future<APIResponse<bool>> updateNote(NoteCreate note, String noteID){
    return http.put(API+'/notes/$noteID', headers: headers, body: json.encode(note.toJson()))
        .then((value) {
      print(value.statusCode);
      if(value.statusCode == 204){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: null, error: true, errorMessage: "${value.statusCode} ${json.decode(value.body)['title']}");
    }).catchError((_) => APIResponse<bool>(data: null, error: true, errorMessage: "An error has occured"));
  }

  Future<APIResponse<bool>> deleteNote(String noteID){
    return http.delete(API+'/notes/'+noteID, headers: headers).then((value){
      if(value.statusCode == 204){
        return APIResponse<bool>(data: true);
      } else {
        return APIResponse<bool>(error: true, errorMessage: "${value.statusCode} ${json.decode(value.body)['title']}");
      }
    }).catchError((_) => APIResponse<bool>(data: null, error: true, errorMessage: "An error has occured"));
  }

}
