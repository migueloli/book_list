import 'package:barcode_scan/barcode_scan.dart';
import 'package:book_list/controllers/book_list.dart';
import 'package:book_list/models/book/book.dart';
import 'package:book_list/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBookScreen extends StatefulWidget {

  final Book book;

  NewBookScreen({this.book});

  @override
  _NewBookScreenState createState() => _NewBookScreenState();
}

class _NewBookScreenState extends State<NewBookScreen> {

  Book _book;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _isbnController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();

    if(widget.book != null && _book == null){
      _book = widget.book;
    }

    if(_book == null){
      _book = Book();
    }

    _isbnController.text = _book.isbn;
  }

  @override
  Widget build(BuildContext context) {
    const _spacing = SizedBox(height: 16,);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16,),
          children: <Widget>[
            TextFormField(
              initialValue: _book.title,
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.title),
                labelText: "Titulo",
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (title) {
                if(title.length < 3) {
                  return "O titulo precisa ter ao menos 3 caracteres.";
                }

                return null;
              },
              onSaved: (title) {
                _book.title = title;
              },
            ),
            _spacing,
            TextFormField(
              initialValue: _book.author,
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.person_outline),
                labelText: "Autor",
                labelStyle: TextStyle(color: Colors.white),
              ),
              onSaved: (author) {
                _book.author = author;
              },
            ),
            _spacing,
            TextFormField(
              initialValue: _book.category,
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.category),
                labelText: "Categoria",
                labelStyle: TextStyle(color: Colors.white),
              ),
              onSaved: (category) {
                _book.category = category;
              },
            ),
            _spacing,
            TextFormField(
              initialValue: _book.publisher,
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.people),
                labelText: "Editora",
                labelStyle: TextStyle(color: Colors.white),
              ),
              onSaved: (publisher) {
                _book.publisher = publisher;
              },
            ),
            _spacing,
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _isbnController,
//                    initialValue: _book.isbn,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      icon: const Icon(Icons.bookmark),
                      labelText: "ISBN",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onSaved: (isbn) {
                      _book.isbn = isbn;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    try {
                      _book.isbn = await BarcodeScanner.scan();
                      _isbnController.text = _book.isbn;
                    } catch (e) {
                      if (e.code == BarcodeScanner.CameraAccessDenied) {
                        setState(() {
                          print('The user did not grant the camera permission!');
                        });
                      } else {
                        print('Unknown error: $e');
                      }
                    }
                  },
                )
              ],
            ),
            _spacing,
            Row(
              children: <Widget>[
                Icon(Icons.format_list_bulleted),
                const SizedBox(width: 16,),
                Expanded(
                  child: FormField<int>(
                    initialValue: _book.status,
                    builder: (state) {
                      return DropdownButton(
                        value: status[state.value],
                        isExpanded: true,
                        onChanged: (value) {
                          _book.status = status.indexOf(value);
                          state.didChange(_book.status);
                        },
                        underline: Container(
                          padding: const EdgeInsets.only(top: 44),
                          height: 30,
                          child: Divider(color: Colors.white,),
                        ),
                        items: status.map<DropdownMenuItem>((title) {
                          return DropdownMenuItem(
                            child: Text(title),
                            value: title,
                          );
                        }).toList(),
                      );
                    }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if(!_formKey.currentState.validate()){
            return;
          }

          _formKey.currentState.save();

          if(_book.id > 0){
            await Provider.of<BookList>(context, listen: false).updateBook(_book);
          } else {
            await Provider.of<BookList>(context, listen: false).addBook(_book);
          }

          Navigator.of(context).pop();
        },
        label: widget.book == null ? Text("Cadastrar") : Text("Atualizar"),
      ),
    );
  }

}
