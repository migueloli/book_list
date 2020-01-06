import 'package:book_list/models/book/book.dart';
import 'package:book_list/models/book/book_dao.dart';
import 'package:mobx/mobx.dart';

part 'book_list.g.dart';

enum BookListState {
  IDLE,
  LOAD,
  ERROR
}

class BookList = _BookList with _$BookList;

abstract class _BookList with Store {

  final BookDao _dao;

  _BookList() : _dao = BookDao();

  @observable
  ObservableFuture<List<Book>> _pendBooksFuture;

  @observable
  ObservableFuture<List<Book>> _readBooksFuture;

  @observable
  ObservableList<Book> pendingBooks = ObservableList<Book>();

  @observable
  ObservableList<Book> readBooks = ObservableList<Book>();

  @computed
  BookListState get pendBooksStatus {
    if(_pendBooksFuture == null
        || _pendBooksFuture.status == FutureStatus.fulfilled){
      return BookListState.IDLE;
    }
    return _pendBooksFuture.status == FutureStatus.pending
        ? BookListState.LOAD
        : BookListState.ERROR;
  }

  @computed
  BookListState get readBooksStatus {
    if(_readBooksFuture == null
        || _readBooksFuture.status == FutureStatus.fulfilled){
      return BookListState.IDLE;
    }
    return _readBooksFuture.status == FutureStatus.pending
        ? BookListState.LOAD
        : BookListState.ERROR;
  }

  @action
  Future addBook(Book book) async {
    book = await _dao.insert(book);
    if(book.id > 0) {
      if(book.status == 0){
        pendingBooks.add(book);
      } else if(book.status == 1){
        readBooks.add(book);
      }
    }
  }

  @action
  Future removeBook(Book book) async {
    var result = await _dao.delete(book.id);
    if(result > 0) {
      if(book.status == 0){
        pendingBooks.remove(book);
      } else if(book.status == 1){
        readBooks.remove(book);
      }
    }
  }

  @action
  Future updateBook(Book book) async {
    int posPend = pendingBooks.indexOf(book);
    if(posPend > -1) {
      pendingBooks.removeAt(posPend);
    }
    int posRead = readBooks.indexOf(book);
    if(posRead > -1) {
      readBooks.removeAt(posRead);
    }

    await _dao.update(book);

    if(book.status == 0){
      if(posPend > -1) {
        pendingBooks.insert(posPend, book);
      }else{
        pendingBooks.add(book);
      }
    } else if(book.status == 1){
      if(posRead > -1) {
        readBooks.insert(posRead, book);
      } else {
        readBooks.add(book);
      }
    }
  }

  @action
  Future getPendingBooks() async {
    try {
      pendingBooks.clear();
      (await _dao.select(st: 0)).forEach((map) {
        pendingBooks.add(Book.fromMap(map));
      });
    }catch(e){
      print(e.toString());
    }
  }

  @action
  Future getReadBooks() async {
    try {
      readBooks.clear();
      (await _dao.select(st: 1)).forEach((map) {
        readBooks.add(Book.fromMap(map));
      });
    }catch(e){
      print(e.toString());
    }
  }

}