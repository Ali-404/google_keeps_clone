import 'package:flutter/material.dart';
import 'package:google_keeps_clone/classes/notesProvider.dart';
import 'package:google_keeps_clone/pages/home.dart';
import "package:google_keeps_clone/classes/themeProvider.dart";
import 'package:provider/provider.dart';

void main() {
  runApp(
    
    MultiProvider( // create the provider
      providers: [
        // theme provider 
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        // class provider 
        ChangeNotifierProvider(
          create: (_) => NoteProvider(),
        ),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteProvider>(context, listen: false).loadNotesFromDatabase();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: Provider.of<ThemeProvider>(context).currentTheme, 
      home: const Home(),
      
      debugShowCheckedModeBanner: false,
      
    );
  }
}
