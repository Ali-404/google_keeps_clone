import 'dart:convert';
import 'package:google_keeps_clone/classes/note_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBase {

  static saveNotes(List<NoteClass>? notes) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    String jsonNotes = jsonEncode(notes!.map((note) => note.toJson()).toList());
    await storage.setString("notes", jsonNotes);
  }


  static saveTheme(String themeName) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    await storage.setString("theme", themeName);

  }

  static saveViewMode(int viewMode) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    await storage.setInt("view", viewMode);
  }

  static Future<List<NoteClass>> getSavedNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonList = prefs.getString('notes');
    
    if (jsonList != null) {
      List<dynamic> jsonDecoded = jsonDecode(jsonList);
      List<NoteClass> notes = jsonDecoded.map((note) => NoteClass.fromJson(note)).toList();
      return notes;
    } else {
      return [];
    }
  }


  static Future<String> getSavedTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? themeData = prefs.getString('theme');

    if (themeData != null){
      return themeData;
    }else {
      return "light";
    }
  }

  static Future<int> getSavedView() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? viewMode = prefs.getInt('view');
    if (viewMode != null){
    return viewMode;
    }else {
      return 2;
    }
  }

}