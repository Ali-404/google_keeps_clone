import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_keeps_clone/classes/themeProvider.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {

  final TextEditingController? searchText;
  const Header({super.key,required this.searchText});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {


  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: widget.searchText,
              decoration: const InputDecoration(
                hintText: "Search for notes",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // toggle view
            ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
            if (themeProvider.currentView == 1){
              themeProvider.setViewMode(2);
            }else {
              themeProvider.setViewMode(1);
            }
          },
          icon: Icon(Provider.of<ThemeProvider>(context,).currentViewIcon),
        ),
        
      ],
    );
  }
}
