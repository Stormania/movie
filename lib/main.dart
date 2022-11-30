//import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviesPage(
        title: 'Movies',
      ),
    ),
  );
}

class Movies extends StatelessWidget {
  const Movies({super.key});
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // ignore: always_specify_types
          colors: [
            Colors.blue,
            Colors.purple,
          ],
        ),
      ),
    );
  }
}

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key, required this.title});
  final String title;
  @override
  State<MoviesPage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviesPage> {
  bool _isLoading = true;
  final List<String> _titleMovie = <String>[];
  final List<String> _imageMovie = <String>[];
  final List<int> _yearMovie = <int>[];
  final List<int> _runtimeMovie = <int>[];

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  void _getMovies() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json')) //
        .then((Response response) {
      response.body;

      final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
      final List<dynamic> movies = data['movies'] as List<dynamic>;

      final Iterable<String> titleMovie = movies //
          .cast<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) => item['title'] as String);

      final Iterable<String> imageMovie = movies //
          .cast<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) => item['medium_cover_image'] as String);

      final Iterable<int> yearMovie = movies //
          .cast<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) => item['year'] as int);

      final Iterable<int> runtimeMovie = movies //
          .cast<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> item) => item['runtime'] as int);

      setState(() {
        _isLoading = false;
        _titleMovie.addAll(titleMovie);
        _imageMovie.addAll(imageMovie);
        _yearMovie.addAll(yearMovie);
        _runtimeMovie.addAll(runtimeMovie);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  const SizedBox(height: 150),
                  AnimatedContainer(
                    duration: const Duration(
                      seconds: 1,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.network(_imageMovie[index]),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Text(
                        _titleMovie[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Release Year: ${_yearMovie[index]}',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'Duration: ${_runtimeMovie[index]} minutes',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
