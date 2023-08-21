// ignore_for_file: unused_field

import 'package:hive_flutter/hive_flutter.dart';

class ToDoozieDatabase {
  List ToDoList = [];

  //ref. mybox
  final _mybox = Hive.box("mybox");

  //run this method if this is the first time opening the app
  void createInitialData() {
    ToDoList = [
      ["Sample Task", false],
      ["Completed Task", true]
    ];
  }

  //load the data from the database
  void loadData() {
    ToDoList = _mybox.get("TODOLIST");
  }

  //update the database
  void updateData() {
    _mybox.put("TODOLIST", ToDoList);
  }
}
