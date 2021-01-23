import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book.dart';
import '../favorite_screen.dart';

class BooksHelper {
  final String urlKey = '&key=AIzaSyCDhlMQ47fuD1EK6-uHB76zufGkX6WubGc';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/books/v1/';

  Future<List<dynamic>> getBooks(String query) async {
    final String url = urlBase + urlQuery + query + urlKey;
    Response result = await http.get(url);

    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final booksMap = jsonResponse['items'];
      List<dynamic> books = booksMap.map((i) => Book.fromJson(i)).toList();
      return books;
    } else {
      return null;
    }
  }

  Future addToFavorites(Book book) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString(book.id);
    if (id != '') {
      await preferences.setString(book.id, json.encode(book.toJson()));
    }
  }

  Future removeFromFavorites(Book book, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString(book.id);
    if (id != '') {
      await preferences.remove(book.id);
      Navigator.push(context, MaterialPageRoute(builder:
          (context)=> FavoriteScreen()));
    }
  }

  Future<List<dynamic>> getFavorites() async {
    //즐겨찾는 도서들 혹은 빈 목록을 반환한다
    final SharedPreferences prefs = await
    SharedPreferences.getInstance();
    List<dynamic> favBooks = [];
    Set allKeys = prefs.getKeys();
    if (allKeys.isNotEmpty) {
      for(int i = 0; i < allKeys.length; i++) {
        String key = (allKeys.elementAt(i).toString());
        String value = prefs.get(key);
        dynamic json = jsonDecode(value);
        Book book = Book(json['id'], json['title'], json['authors'],
            json['description'], json['publisher']);
        favBooks.add(book);
      }
    }
    return favBooks;
  }

}