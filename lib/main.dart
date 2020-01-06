import 'package:book_list/controllers/book_list.dart';
import 'package:book_list/screen/home/page_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Provider<BookList>(
      create: (_) => BookList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Booklist',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
          primaryColor: Colors.indigo,
          primaryColorDark: Colors.black,
          accentColor: Colors.indigoAccent
        ),
        home: PageScreen(),
      ),
    );
  }

}