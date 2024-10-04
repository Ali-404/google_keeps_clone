
import 'package:flutter/material.dart';
import 'package:google_keeps_clone/classes/note_class.dart';
import 'package:google_keeps_clone/database/db.dart';

class NoteProvider with ChangeNotifier {
  List<NoteClass> _notes = [];

  List<NoteClass> get notes => _notes;

  // Load notes from database on initialization
  NoteProvider() {
    loadNotesFromDatabase();
  }

  void loadNotesFromDatabase() {
    DataBase.getSavedNotes().then((savedNotes) {
      _notes = savedNotes;
      notifyListeners(); // Notify listeners after loading notes
    });
  }

  void addNote(NoteClass note) {
    _notes.add(note);
    DataBase.saveNotes(_notes); // Save updated notes list to database
    notifyListeners(); // Notify listeners after adding note
  }

  void updateNote(int index, NoteClass note) {
    _notes[index] = note;
    DataBase.saveNotes(_notes); // Save updated notes list to database
    notifyListeners(); // Notify listeners after updating note
  }

  void deleteNote(int index) {
    try{
    _notes.removeAt(index);
    DataBase.saveNotes(_notes); 

    }catch(e) {
      print(e);
    }
   
    notifyListeners();
  }
}
