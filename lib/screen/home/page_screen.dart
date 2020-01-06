import 'package:book_list/screen/home/pages/list_page.dart';
import 'package:book_list/screen/new_book/new_book_screen.dart';
import 'package:book_list/util/constants.dart';
import 'package:flutter/material.dart';

class PageScreen extends StatefulWidget {
  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {

  final PageController _pageController = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          ListPage(0),
          ListPage(1),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (page) {
          setState(() {
            _page = page;
          });
          _pageController.animateToPage(
              page,
              duration: Duration(
                  milliseconds: 300
              ),
              curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            title: Text(status[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text(status[1]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewBookScreen(),
        )),
      ),
    );
  }
}
