class NoteForList{
  String noteId;
  String noteTitle;
  DateTime createdDateTime;
  DateTime lastEditDateTime;

  NoteForList({this.noteId, this.noteTitle, this.createdDateTime, this.lastEditDateTime});

  factory NoteForList.fromJson(Map<String, dynamic> item){
    return NoteForList(
        noteId: item['noteID'],
        noteTitle: item['noteTitle'],
        createdDateTime: DateTime.parse(item['createDateTime']),
        lastEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null
    );
  }
}