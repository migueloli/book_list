import 'package:book_list/models/bd_helper.dart';
import 'package:book_list/models/book/book.dart';

class BookDao {

  static final String table = "book";
  static final String id = "id";
  static final String title = "title";
  static final String author = "author";
  static final String category = "category";
  static final String isbn = "isbn";
  static final String publisher = "publisher";
  static final String status = "status";

  static String getCreateSQL() => "CREATE TABLE $table ("
      "$id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$title TEXT, "
      "$author TEXT, "
      "$category TEXT, "
      "$isbn TEXT, "
      "$publisher TEXT, "
      "$status INTEGER "
    ");";

  final BDHelper _helper;

  BookDao() : _helper = BDHelper.internal();

  Future<Book> insert(Book book) async {
    var db = await _helper.db;
    book.id = await db.insert(table, book.toMap());

    return book;
  }

  Future<int> delete(int bookId) async {
    var db = await _helper.db;
    return await db.delete(table, where: "$id = ?", whereArgs: [bookId]);
  }

  Future<int> update(Book book) async {
    var db = await _helper.db;
    return await db.update(
        table,
        book.toMap(),
        where: "$id = ?",
        whereArgs: [book.id]
    );
  }

  Future<List<Map<String, dynamic>>> select({int st = -1}) async {
    var db = await _helper.db;
    String where;
    List<String> args;
    if(st >= 0){
       where = "$status = ?";
       args= [st.toString()];
    }

    return await db.query(table, where: where, whereArgs: args);
  }

}