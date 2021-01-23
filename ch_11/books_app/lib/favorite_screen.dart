import 'package:flutter/material.dart';
import 'ui.dart';
import 'data/books_helper.dart';
import 'main.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  BooksHelper helper;
  List<dynamic> books = [];
  int booksCount;

  @override
  void initState() {
    helper = BooksHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;
    if (MediaQuery.of(context).size.width < 600) {
      isSmall = true;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Books'),
        actions: <Widget>[
          InkWell(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: (isSmall) ? Icon(Icons.home) : Text('Home')
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          InkWell(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child:(isSmall) ? Icon(Icons.star) : Text('Favorites')
            ),
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(20),
            child: Text('My Favorite Books')
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: (isSmall) ? BooksList(books, true) : BooksTable(books, true)
        ),
      ],
      ),
    );
  }


  Future initialize() async {
    books = await helper.getFavorites();
    setState(() {
      booksCount = books.length;
      books = books;
    });
  }

}
