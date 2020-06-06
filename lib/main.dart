import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:noteswithapi/views/notes_list.dart';
import 'services/notes_service.dart';

void setupLocator(){
  GetIt.instance.registerLazySingleton(() => NotesService());
//  GetIt.instance<NotesService>(); To consume it
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoteList(),
    );
  }
}
