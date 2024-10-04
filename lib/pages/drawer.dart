import 'package:flutter/material.dart';
import 'package:google_keeps_clone/classes/themeProvider.dart';
import 'package:provider/provider.dart';


class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  bool isDarkMode = false;


  void ToggleDarkMode(bool){
     final themeProvider = Provider.of<ThemeProvider>(context, listen: false); // get the provider, listen false is necessary cause is in a function

      setState(() {
        isDarkMode = bool;
      }); // change the variable

      bool // call the functions
          ? themeProvider.setDarkmode()
          : themeProvider.setLightMode();

  }

  
 

  @override
  Widget build(BuildContext context) {

    setState(() {
      isDarkMode = Provider.of<ThemeProvider>(context, listen: false).currentTheme == Provider.of<ThemeProvider>(context).darkTheme;
    });

    return  Drawer(
        
        child: SafeArea(
          child: Padding(
            padding:const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: Switch(value: isDarkMode , onChanged: (newV){ToggleDarkMode(newV);}),
                  title:const Text("Dark Mode"),
                  textColor: Provider.of<ThemeProvider>(context).currentTheme?.primaryColor,
                  
                ),
                
              ]
            ),
          ),
        ),
    );
  }
}