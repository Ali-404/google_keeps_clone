import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keeps_clone/classes/notesProvider.dart';
import 'package:google_keeps_clone/classes/themeProvider.dart';
import 'package:google_keeps_clone/components/header.dart';
import 'package:google_keeps_clone/components/note.dart';
import 'package:google_keeps_clone/classes/note_class.dart';
import 'package:google_keeps_clone/pages/create.dart';
import 'package:google_keeps_clone/pages/drawer.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchText = TextEditingController(text: "");

    return Scaffold(
      body: SafeArea(
        child: ListHome(searchText: searchText),
      ),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 150,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Header(searchText: searchText),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (cont) => const CreationPage()),
          )
        },
        foregroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
class ListHome extends StatefulWidget {
  final TextEditingController? searchText;

  const ListHome({super.key, required this.searchText});

  @override
  _ListHomeState createState() => _ListHomeState();
}

class _ListHomeState extends State<ListHome> {
  List<NoteClass> notesList = [];
  List<NoteClass> filteredNotesList = [];

  @override
  void initState() {
    super.initState();


    
    

    Provider.of<ThemeProvider>(context, listen: false).loadTheme();
    Provider.of<ThemeProvider>(context, listen: false).loadView();
    
    widget.searchText!.addListener(_filterNotes);
  }

  @override
  void dispose() {
    widget.searchText!.removeListener(_filterNotes);
    super.dispose();
  }

  void _loadNotes()  {
      setState(() {
        notesList = Provider.of<NoteProvider>(context, listen: true).notes;
        _filterNotes();
      });
  }

  

  void _filterNotes() {
    setState(() {
      if (widget.searchText == null || widget.searchText!.text.isEmpty ) {
        filteredNotesList = notesList;
      } else {
        filteredNotesList = notesList.where((NoteClass note) {
          return note.title.toLowerCase().contains(widget.searchText!.text.toLowerCase()) ||
              note.text.toLowerCase().contains(widget.searchText!.text.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    
    _loadNotes();

    if (filteredNotesList.isEmpty) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(filteredNotesList.isEmpty && notesList.isNotEmpty
                    ? "0 Notes Found"
                    : "You don't have any notes yet."),
              ),
            ),
          ],
        ),
      );
    }

    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        // Assuming noteProvider.notes is not used directly here
        if (widget.searchText!.text.isEmpty) {
          filteredNotesList = notesList;
        }

        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: StaggeredGrid.count(
                crossAxisCount:
                    Provider.of<ThemeProvider>(context).currentView,
                axisDirection: AxisDirection.down,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                children: filteredNotesList
                    .asMap()
                    .map(
                      (key, theNote) => MapEntry(
                        key,
                        InkWell(
                          child: Note(
                            note: theNote,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (cont) => CreationPage(
                                  note: theNote,
                                  noteID: key,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
