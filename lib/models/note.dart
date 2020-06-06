class Note{
  String noteId;
  String noteTitle;
  String content;
  DateTime createdDateTime;
  DateTime lastEditDateTime;

  Note({this.noteId, this.content, this.noteTitle, this.createdDateTime, this.lastEditDateTime});

  factory Note.fromJson(Map<String, dynamic> item){
    return Note(
        noteId: item['noteID'],
        noteTitle: item['noteTitle'],
        content: item['noteContent'],
        createdDateTime: DateTime.parse(item['createDateTime']),
        lastEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null
    );
  }
}