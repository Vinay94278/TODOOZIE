// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_field, unused_local_variable

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoozie/data/database.dart';
import 'ToDoTile.dart';

void main() async {
  //init hive
  await Hive.initFlutter();

  //open a box
  var box = await Hive.openBox('mybox');

  runApp(ToDoozie());
}

class ToDoozie extends StatefulWidget {
  @override
  State<ToDoozie> createState() => _ToDoozieState();
}

class _ToDoozieState extends State<ToDoozie> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ToDoozie",
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: AnimatedSplashScreen(
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Colors.white,
            splash: Image.asset("assets/img/logo.png"),
            nextScreen: ToDoozieHome()));
  }
}

class ToDoozieHome extends StatefulWidget {
  @override
  State<ToDoozieHome> createState() => _ToDoozieHomeState();
}

class _ToDoozieHomeState extends State<ToDoozieHome> {
  //ref. the hive box
  final _mybox = Hive.box('mybox');

  @override
  void initState() {
    // 1st time opening of the box
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  //text controller
  var textcontroller = TextEditingController();

  var textstyle = TextStyle(
      fontSize: 20,
      fontFamily: "LE",
      fontWeight: FontWeight.w500,
      color: Colors.amber);
  ToDoozieDatabase db = ToDoozieDatabase();

  //slidable delete function
  void deleteTask(int index) {
    setState(() {
      db.ToDoList.removeAt(index);
    });
    db.updateData();
  }

  //slidable update function
  void updateTask(int ind) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.grey,
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20,
                runSpacing: 20,
                children: [
                  // Taking User Input About Updated Task Detail
                  TextFormField(
                    controller: textcontroller,
                    decoration: InputDecoration(
                      hintText: "Edit Your Task Here",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //Update button
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              db.ToDoList[ind] = [
                                textcontroller.text.toString(),
                                false
                              ];
                              Navigator.of(context).pop();
                              textcontroller.clear();
                              db.updateData();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Update"),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                ],
              ),
              height: 120,
              width: 180,
              decoration: BoxDecoration(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  //Create new Dialog Box
  void CreateNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.grey,
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 120,
              width: 180,
              decoration: BoxDecoration(color: Colors.grey),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 20,
                runSpacing: 20,
                children: [
                  // Taking User Input About Task Detail
                  TextField(
                    controller: textcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Add Your Task Title"),
                  ),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //save button
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              db.ToDoList.add([textcontroller.text, false]);
                              Navigator.of(context).pop();
                              textcontroller.clear();
                              db.updateData();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Save"),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      //cancel button
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                              textcontroller.clear();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Cancel"),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void CheckBoxChanged(bool? value, int index) {
    setState(() {
      db.ToDoList[index][1] = !db.ToDoList[index][1];
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        // elevation: 0,
        centerTitle: true,
        title: Text("DOOZIE PLANNER", style: textstyle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CreateNewTask();
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          itemCount: db.ToDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              TaskName: db.ToDoList[index][0],
              TaskCom: db.ToDoList[index][1],
              onChanged: (value) {
                CheckBoxChanged(value, index);
              },
              deletefunction: (Context) => deleteTask(index),
              updatefunction: (Context) => updateTask(index),
            );
          },
        ),
      ),
    );
  }
}
