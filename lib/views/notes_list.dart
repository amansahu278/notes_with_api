import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:noteswithapi/models/api_response.dart';
import 'package:noteswithapi/models/notes_for_list.dart';
import 'package:noteswithapi/services/notes_service.dart';
import 'package:noteswithapi/views/delete_note.dart';
import 'package:noteswithapi/views/modify_note.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.instance<NotesService>();

  APIResponse<List<NoteForList>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  void _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNotesList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes list"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NoteModify())).then((_){
                _fetchNotes();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (context){
          if(_isLoading){
            return Center(child: CircularProgressIndicator());
          }
          if(_apiResponse.error){
            return Center(
              child: Text(_apiResponse.errorMessage),
            );
          }
          return ListView.separated(
            itemCount: _apiResponse.data.length,
            separatorBuilder: (context, _) => Divider(
              height: 1,
              color: Colors.green,
            ),
            itemBuilder: (context, index) {
              return Dismissible(
                background: Container(
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.red,
                    child: Align(child: Icon(Icons.delete, color: Colors.white,),alignment: Alignment.centerLeft,)
                ),
                key: ValueKey(_apiResponse.data[index].noteId),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  setState(() {
                    _apiResponse.data.removeAt(index);
                  });
                },
                confirmDismiss: (direction) async {
                  final result = await showDialog(context: context, builder: (context) => NoteDelete());
                  var message;
                  var deleteResult;
                  if(result){
                    deleteResult = await service.deleteNote(_apiResponse.data[index].noteId);
                    if(deleteResult != null && deleteResult.data == true){
                      message = "Note deleted!";
                    }else{
                      message = deleteResult.errorMessage ?? 'An error occurred';
                    }
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 1),));
                    return deleteResult.data ?? false;
                  }
                  return result;
                },
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteModify(
                          noteID: _apiResponse.data[index].noteId,
                        ))).then((value){
                          _fetchNotes();
                    });
                  },
                  title: Text(
                    _apiResponse.data[index].noteTitle,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(
                      'Last edited on ${formatDateTime(_apiResponse.data[index].lastEditDateTime ?? _apiResponse.data[index].createdDateTime)}'),
                ),
              );
            },
          );
        },
      )
    );
  }
}
