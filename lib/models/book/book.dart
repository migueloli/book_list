import 'package:book_list/models/book/book_dao.dart';

class Book {
  int id;
  String title;
  String author;
  String category;
  String isbn;
  String publisher;
  int status;

  Book({this.id = 0, this.title = "", this.author = "", this.category = "", this.isbn = "",
      this.publisher = "", this.status = 0});

  Book.fromMap(Map<String, dynamic> map){
    id = map[BookDao.id];
    title = map[BookDao.title];
    author = map[BookDao.author];
    category = map[BookDao.category];
    isbn = map[BookDao.isbn];
    publisher = map[BookDao.publisher];
    status = map[BookDao.status];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      BookDao.title: title,
      BookDao.author: author,
      BookDao.category: category,
      BookDao.isbn: isbn,
      BookDao.publisher: publisher,
      BookDao.status: status,
    };

    if(id > 0){
      map[BookDao.id] = id;
    }

    return map;
  }

}