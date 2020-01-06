import 'package:book_list/controllers/book_list.dart';
import 'package:book_list/models/book/book.dart';
import 'package:book_list/screen/home/widgets/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {

  final int page;

  ListPage(this.page);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  BookList _bookList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var bookList = Provider.of<BookList>(context);
    if(_bookList != bookList){
      _bookList = bookList;
      if(widget.page == 0) {
        _bookList.getPendingBooks();
      } else {
        _bookList.getReadBooks();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if(widget.page == 0) {
          return RefreshIndicator(
            onRefresh: _bookList.getPendingBooks,
            child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    BookTile(
                      _bookList.pendingBooks[index],
                      onLongPress: () {
                        Book book = _bookList.pendingBooks[index];
                        if(book.status == 0) {
                          book.status = 1;
                          _bookList.updateBook(book);
                        }
                      },
                    ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: _bookList.pendingBooks.length
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _bookList.getReadBooks,
            child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    BookTile(
                      _bookList.readBooks[index],
                        onLongPress: () {
                          Book book = _bookList.readBooks[index];
                          if(book.status == 1) {
                            book.status = 0;
                            _bookList.updateBook(book);
                          }
                        }
                    ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: _bookList.readBooks.length
            ),
          );
        }
      },
    );
  }

}
