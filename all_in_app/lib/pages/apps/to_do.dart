import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_in_app/components/custom_app_bar.dart';
import 'package:all_in_app/components/floatingbutton_note.dart';
import 'package:all_in_app/components/save_cancel_button.dart';
import 'package:all_in_app/components/todo_tile.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final TextEditingController _controller = TextEditingController();
  List<List<dynamic>> toDoList = [];

  // Salvarea în local storage
  Future<void> saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(toDoList);
    await prefs.setString('todo_list', encodedData);
  }

  // Încărcarea din local storage
  Future<void> loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('todo_list');
    if (savedData != null) {
      setState(() {
        toDoList = List<List<dynamic>>.from(
          jsonDecode(savedData).map((item) => List<dynamic>.from(item)),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadToDoList(); // Încărcăm task-urile la inițializare
  }

  void cancelTask() {
    Navigator.pop(context);
    _controller.clear();
  }

  void saveTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
    });
    saveToDoList(); // Salvăm local
    cancelTask();
  }

  Future _createTask() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create task'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter your task',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
          actions: [
            SaveCancelButton(name: 'Cancel', onPressed: cancelTask),
            SaveCancelButton(name: 'Save', onPressed: saveTask),
          ],
        );
      },
    );
  }

  void changeCheckbox(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
    saveToDoList(); // Salvăm modificările local
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    saveToDoList(); // Salvăm după ștergere
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'To Do', appBarColor: Colors.purple),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (BuildContext context, int index) {
          return TodoTile(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => changeCheckbox(value, index),
            onDelete: () => deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingbuttonNote(
        onPressed: _createTask,
        buttonColor: Colors.purple,
      ),
    );
  }
}
