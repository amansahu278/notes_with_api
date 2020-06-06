import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:noteswithapi/models/note.dart';
import 'package:noteswithapi/models/note_create.dart';
import 'package:noteswithapi/services/notes_service.dart';

class NoteModify extends StatefulWidget {
  String noteID;
  bool get isEditing => noteID != null;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();

  NotesService get service => GetIt.I<NotesService>();
  String errorMessage;
  Note note;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    if (widget.isEditing)
    {
      service.getNote(widget.noteID)
          .then((response){
        if(response.error){
          errorMessage = response.errorMessage;
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.content;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? "Editing note" : "Create Note"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Note title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Content",
                hintText: "Note Content"
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: RaisedButton(
              padding: EdgeInsets.all(10),
              child: Text("Submit", style: TextStyle(color: Colors.white),),
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                final note = NoteCreate(
                  noteTitle: _titleController.text,
                  noteContent: _contentController.text,
                );
                var result;
                if(widget.isEditing){
                  result = await service.updateNote(note, widget.noteID);
                } else {
                  result = await service.createNote(note);
                }
                setState(() {
                  _isLoading = false;
                });

                final title = 'Done';
                final text = result.error ? (result.errorMessage ?? 'An error occurred') : widget.isEditing ? "Note Updated!" : "Note Created!";
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(title),
                      content: Text(text),
                      actions: <Widget>[
                        FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))
                      ],
                    )
                ).then((value) {
                  if(result.data){
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
