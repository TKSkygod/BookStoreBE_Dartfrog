// ignore_for_file: body_might_complete_normally_nullable, cast_nullable_to_non_nullable, prefer_single_quotes, lines_longer_than_80_chars, unnecessary_brace_in_string_interps

import 'dart:async';

import '../constant/constant.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/book.dart';

class IBookRepo {
  Future<int>? saveBook(Book book) {}
  void queryBookList() {}
  void searchBookList(String? title) {}
}

class BookRepository implements IBookRepo {
  BookRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<int> saveBook(Book book) async {
    final completer = Completer<int>();
    return completer.future;
  }

  @override
  Future<List<Book>> queryBookList() async {
    final completer = Completer<List<Book>>();
    const query = 'SELECT * FROM books;';
    final result = await _db.executor.query(query);
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        "no result",
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    } else {
      final books = <Book>[];
      for (var i = 0; i < result.length; i++) {
        final row = result[i].toColumnMap();
        books.add(
          Book(
            book_id: row['book_id'].toString(),
            title: row['title'].toString(),
            description: row['description'].toString(),
            score: row['score'].toString(),
            image: row['image'].toString(),
            price: row['price'].toString(),
            number_books: row['number_books'].toString(),
            shipcost: row['shipcost'].toString(),
            authorName: row['authorname'].toString(),
            shopName: row['shopname'].toString(),
            shop_image: row['shop_image'].toString(),
            quantity: row['quantity'].toString(),
          ),
        );
      }
      completer.complete(books);
    }
    return completer.future;
  }

  @override
  Future<List<Book>> searchBookList(String? title) async {
    final completer = Completer<List<Book>>();
    const query = '''
          SELECT * FROM books WHERE title LIKE @title;
        ''';
    final params = {
      'title': '%$title%',
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        "no result",
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    } else {
      final books = <Book>[];
      for (var i = 0; i < result.length; i++) {
        final row = result[i].toColumnMap();
        books.add(
          Book(
            book_id: row['book_id'].toString(),
            title: row['title'].toString(),
            description: row['description'].toString(),
            score: row['score'].toString(),
            image: row['image'].toString(),
            price: row['price'].toString(),
            number_books: row['number_books'].toString(),
            shipcost: row['shipcost'].toString(),
            authorName: row['authorname'].toString(),
            shopName: row['shopname'].toString(),
            shop_image: row['shop_image'].toString(),
            quantity: row['quantity'].toString(),
          ),
        );
      }
      completer.complete(books);
    }
    return completer.future;
  }
}
