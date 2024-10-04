import 'package:flutter/material.dart';
import 'package:google_keeps_clone/classes/note_class.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class Note extends StatefulWidget {
  
  final NoteClass note;

  const Note({super.key, required this.note });
  

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {

  final _TxtController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    

    final NoteClass note = widget.note;
    _TxtController.value = TextEditingValue(text: note.text);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width *0.45,
        
        padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        decoration: BoxDecoration(
          color: note.color,
          boxShadow: const[
            BoxShadow(blurRadius: 5,offset: Offset(0, 5),spreadRadius: 1, color: Colors.black26)
          ],
          borderRadius: BorderRadius.circular(15)
      
        ),
        child:Padding(
          padding:const EdgeInsets.all(8.0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [ 
              //! TITLE
              if (note.title.isNotEmpty) 
                Text(note.title, style: TextStyle(
                color: note.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
                ),
              
              //! PARAG
              if (note.text.isNotEmpty)
                MarkdownAutoPreview(controller: _TxtController,  style: TextStyle(
                color: note.textColor,),
                readOnly: true,
                expands: false,
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}