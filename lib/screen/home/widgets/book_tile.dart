import 'package:book_list/models/book/book.dart';
import 'package:book_list/screen/new_book/new_book_screen.dart';
import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {

  final Book book;
  final VoidCallback onLongPress;

  BookTile(this.book, {this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.status == 0
          ? Icon(Icons.bookmark_border)
          : Icon(Icons.bookmark),
      title: Text(book.title),
      subtitle: book.author.isNotEmpty ? Text(book.author) : null,
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewBookScreen(book: book),
      )),
      onLongPress: onLongPress,
    );
  }
}
