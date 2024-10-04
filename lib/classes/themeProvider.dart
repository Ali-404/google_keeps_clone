import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_keeps_clone/database/db.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData? currentTheme;
  String currentThemeName = "light";
  int currentView = 2;
  IconData currentViewIcon = Icons.list;

  
  // LIGHT THEME
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme:const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 2,
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      )
    ),
  );


  // DARK THEME
  ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark, // DarkMode
      scaffoldBackgroundColor: const Color.fromARGB(255, 34, 19, 60),
      drawerTheme:const DrawerThemeData(backgroundColor:  Color.fromARGB(255, 39, 24, 80)),
      primaryColor: Colors.white,
      appBarTheme:const AppBarTheme(
      backgroundColor: Colors.deepPurpleAccent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
      )
    ),
      
  );

  setLightMode() {
    currentTheme = lightTheme;
    currentThemeName = "light";
    DataBase.saveTheme(currentThemeName);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark 
      
    ));
    notifyListeners();
  }

  setDarkmode() {
    currentTheme = darkTheme;
    currentThemeName = "dark";
    
    // save
    DataBase.saveTheme(currentThemeName);
    
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.light, 
      statusBarBrightness: Brightness.light, 
      
    ));

    notifyListeners();
  }



  setViewMode(int viewMode){
    currentView = viewMode;
    currentViewIcon = viewMode == 1 ? Icons.apps : Icons.list; 
    
    DataBase.saveViewMode(viewMode);

    
    notifyListeners();
  }


  loadTheme() async{ 
    await DataBase.getSavedTheme().then((savedThemeName){
      currentThemeName = savedThemeName;
      savedThemeName == "dark" ? setDarkmode() : setLightMode();
      notifyListeners();
    });
  }

  loadView() async{
    await DataBase.getSavedView().then((savedView){
      currentView = savedView;
      currentViewIcon = savedView == 1 ? Icons.apps : Icons.list; 
      notifyListeners();
    });
  }


}