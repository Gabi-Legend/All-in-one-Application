import 'package:all_in_app/components/custom_app_bar.dart';
import 'package:all_in_app/components/floatingbutton_note.dart';
import 'package:all_in_app/components/note.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController _controller = TextEditingController();

  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Încarcă notițele salvate din shared_preferences
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedNotes = prefs.getString('notes');
    if (savedNotes != null) {
      setState(() {
        _notes = List<String>.from(jsonDecode(savedNotes));
      });
    }
  }

  // Salvează notițele în shared_preferences
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes', jsonEncode(_notes));
  }

  void _cancel() {
    Navigator.pop(context);
    _controller.clear();
  }

  void _save() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _notes.add(_controller.text);
      });
      _saveNotes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note added!')),
      );
      _cancel();
    }
  }

  void _delete(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted!')),
    );
  }

  Future<void> onPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Center(
              child: Text(
                'Create a Note',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your note here...',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
              maxLines: 3,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: _cancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notes',
        appBarColor: Colors.greenAccent,
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                'No notes found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Note(
                  title: _notes[index],
                  onLongPress: () => _delete(index),
                );
              },
            ),
      floatingActionButton: FloatingbuttonNote(
        onPressed: onPressed,
        buttonColor: Colors.green,
      ),
    );
  }
}
