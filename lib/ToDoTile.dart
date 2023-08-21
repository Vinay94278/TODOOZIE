// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  String TaskName;
  bool TaskCom;
  Function(bool?)? onChanged;
  Function(BuildContext)? deletefunction;
  Function(BuildContext)? updatefunction;

  ToDoTile(
      {super.key,
      required this.TaskName,
      required this.TaskCom,
      required this.onChanged,
      required this.deletefunction,
      required this.updatefunction});

  var textstyle = TextStyle(
      fontSize: 20,
      fontFamily: "LE",
      fontWeight: FontWeight.w500,
      color: Colors.amber);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Slidable(
        startActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onPressed: updatefunction,
            icon: Icons.edit,
            backgroundColor: Colors.green,
          )
        ]),
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onPressed: deletefunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ]),
        child: Container(
          // width: ,
          // color: Colors.deepPurple,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200.withOpacity(0.3)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              // mainAxisAlignment: ma,
              children: [
                //CheckBox
                Checkbox(
                    value: TaskCom,
                    onChanged: onChanged,
                    activeColor: Colors.black,
                    checkColor: Colors.green),
                //Sized Box for space between checkbox and text
                SizedBox(
                  width: 10,
                ),
                //TaskName
                Expanded(
                  child: Container(
                      // width: ,
                      child: Text(TaskName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "LE",
                            fontWeight: FontWeight.w500,
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
