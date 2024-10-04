import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_keeps_clone/classes/note_class.dart';
import 'package:google_keeps_clone/classes/notesProvider.dart';
import 'package:google_keeps_clone/classes/themeProvider.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:provider/provider.dart';

class CreationPage extends StatefulWidget 
{

  final NoteClass? note;
  final int? noteID;
  const CreationPage({super.key,this.note, this.noteID});

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {

  Color textColor = Colors.white;
  Color bgColor = Colors.deepPurpleAccent;


  @override
  void initState() {
    super.initState();
    if (widget.note != null){
      setState(() {
        textColor = widget.note!.textColor;
        bgColor = widget.note!.color;
      });
    }
  } 


  // delete

  Future _ShowDeleteAlert(pop) async{
    return showDialog(context: context, builder: (context) =>  AlertDialog(
      title: const Text("Attention", style: TextStyle(color: Colors.white),), 
      backgroundColor: Colors.red[500],
      content: const Text("Are you sure you want to delete this note?"),
      contentTextStyle: const TextStyle(color: Colors.white),
      actions: [


        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white),),),


        TextButton(onPressed: ()  {
          pop();
          // 
          Provider.of<NoteProvider>(context, listen: false).deleteNote(widget.noteID!);
          // 
          Navigator.pop(context);
        }, child: const Text("Delete This Note", style: TextStyle(color: Colors.white),),
        ),
      ]
    ));
  }

  Future<void> _ShowColorPicker(String title, Color color, bool isTitleColor) async {
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(pickerColor: color, onColorChanged: (newColor){
            setState(() {
              if (isTitleColor){
                textColor = newColor;
              }else {
                bgColor = newColor;
              }
            });
          },enableAlpha: false,)
        ),
        actions: [
          TextButton(
            child:const Text("Done"),
            onPressed: (){
              // change color state
              Navigator.of(context).pop();
            },
          ),
        ],
        
      );
    },
  );
}

  Future<void> _SaveDialog(save,pop) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Saving Alert'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Would you like to Save this Note ?'),
            ],
          ),
        ),
        actions: <Widget>[
          
          TextButton(
            child: const Text('Keep Editing'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
              pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              save();

            },
          ),
        ],
      );
    },
  );
}

  // title controller

 

  @override
  Widget build(BuildContext context) {

      String titleText = widget.note != null ? widget.note!.title  : "";
      String noteText = widget.note != null ? widget.note!.text  : "";

      final TextEditingController titleController = TextEditingController(text: titleText);

      final TextEditingController noteController = TextEditingController(text: noteText);

      

        void pop() async {
          final navigator = Navigator.of(context);
          navigator.pop();
      }

      void remove() async {
        
        await _ShowDeleteAlert(pop);
      }

       void onBack(bool didPop) async {

        if (didPop){
          return;
        }


        void save() async {
          NoteProvider noteProvider = Provider.of<NoteProvider>(context, listen: false);
          NoteClass newNote = NoteClass(titleController.text, noteController.text, DateTime.now(),bgColor, textColor);
          
          if (widget.note != null && widget.noteID != null){
            noteProvider.updateNote(widget.noteID!, newNote);
          }else {
            noteProvider.addNote(newNote);
          }
          
          
          
          
          // else if edit
          
          pop();
        }
        if (noteController.text.isEmpty && titleController.text.isEmpty){
          pop();
          return;
        }
        await _SaveDialog(save, pop);
        
      }
    
      // status bar


      

      SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Provider.of<ThemeProvider>(context,listen: false).currentTheme?.brightness,
      statusBarBrightness: Provider.of<ThemeProvider>(context,listen: false).currentTheme?.brightness 
      
    ));

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async => onBack(didPop),
      child: Scaffold(

        // bottom bar
       

        // app bar
        appBar: AppBar(
          title:const Text(""),
          scrolledUnderElevation: 0,
          actions: [
            IconButton(onPressed: () => _ShowColorPicker("Title Color", textColor, true), icon:const Icon(Icons.border_color)),
            IconButton(onPressed: () => _ShowColorPicker("Background Color", bgColor, false), icon:const Icon(Icons.color_lens)),

            if (widget.note != null)
            IconButton(onPressed: () => remove(), icon:const Icon(Icons.delete)),
          ],
        ),
        
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(maxLines: 1, style: TextStyle(
                fontSize: 30,
                color: Provider.of<ThemeProvider>(context).currentTheme?.primaryColor,
              ),
              controller: titleController,
              decoration: InputDecoration(hintText: "Title",hintStyle: TextStyle(
                color: Provider.of<ThemeProvider>(context).currentTheme?.primaryColor,
              )),
              ),
              Expanded(
                //change add button to preview
                child: MarkdownField(
                  style: TextStyle(
                    color: Provider.of<ThemeProvider>(context).currentTheme?.primaryColor,
                    
                  ),
                  emojiConvert: true,

                  maxLines: null,
                  controller: noteController,
                  // keyboardType: TextInputType.multiline,
                  decoration:  InputDecoration(
                  hintText: "Note",
                  hintStyle: TextStyle(
                    color: Provider.of<ThemeProvider>(context).currentTheme?.primaryColor,
                  ),
                  border: InputBorder.none,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}