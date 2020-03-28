import 'dart:convert';

import 'package:flutterrestapi/models/api_response.dart';
import 'package:flutterrestapi/models/note.dart';
import 'package:flutterrestapi/models/note_for_listing.dart';
import 'package:flutterrestapi/models/note_insert.dart';
import 'package:http/http.dart' as http;

class NotesService{

  static const API='http://api.notes.programmingaddict.com';
  static const header={
    'apiKey':'444c57f4-e15a-42d2-b870-2fef4dca7358',
    'Content-Type':'application/json'
  };


  Future<APIResponse<List<NoteForListing>>> getNotesList(){
    return http.get(API + '/notes',headers: header)
        .then((data){
       if(data.statusCode==200){
         final jsonData=json.decode(data.body);
         final notes=<NoteForListing>[];
         for(var item in jsonData){
           notes.add(NoteForListing.fromJson(item));
         }
         return APIResponse<List<NoteForListing>>(data : notes);
       }
       return APIResponse<List<NoteForListing>>(error:  true, errorMessage: 'An error occured');
    })
    .catchError((_)=> APIResponse<List<NoteForListing>>(error:  true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http.get(API + '/notes/' + noteID, headers: header)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) =>
        APIResponse<Note>(error: true, errorMessage: 'An error occured'));
  }


  Future<APIResponse<bool>> createNote(NoteInsert item) {
    return http.post(API + '/notes' , headers: header, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data:true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
}