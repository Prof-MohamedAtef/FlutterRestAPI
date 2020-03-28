import 'package:flutter/material.dart';
import 'package:flutterrestapi/models/note.dart';
import 'package:flutterrestapi/services/notes_service.dart';
import 'package:get_it/get_it.dart';

class NoteModify extends StatefulWidget {

  final String noteID;



  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();

}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage;
  Note note;

  TextEditingController _titleController= TextEditingController();
  TextEditingController _contentController= TextEditingController();

  bool _isLoading=false;

  @override
  void initState() {
    super.initState();


    if(isEditing){
      setState(() {
        _isLoading=true;
      });
      notesService.getNote(widget.noteID)
          .then((response){

        setState(() {
          _isLoading=false;
        });

        if(response.error){
          errorMessage=response.errorMessage ?? 'An error occurred';
        }

        note=response.data;
        _titleController.text=note.noteTitle;
        _contentController.text=note.noteContent;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'Create note' )),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _isLoading ? Center(child:  CircularProgressIndicator()) :  Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: 'Note title'
                ),
              ),
              Container(height: 8),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                    hintText: 'Note content'
                ),
              ),

              Container(height: 16),
              SizedBox(
                width: double.infinity,
                height: 35,
                child: RaisedButton(
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    if(isEditing){
                      //update note in api
                    }else{
                      // create note in api
                    }
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}