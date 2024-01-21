import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieflix/models/movie.dart' as models;
import 'package:movieflix/models/movie_detail.dart' as models;

class Movie {
  static const baseUrl = 'https://movies-api.nomadcoders.workers.dev/';

  static Future<String> request(String path) async {
    final url = Uri.parse("$baseUrl$path");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Error();
    }
    return response.body;
  }

  static Future<List<models.Movie>> fetchPopularMovies() async {
    List<models.Movie> movies = [];
    String body = await request('popular');
    final moviesJson = jsonDecode(body);
    for (var movieJson in moviesJson['results']) {
      final movie = models.Movie.fromJson(movieJson);
      movies.add(movie);
    }
    return movies;
  }

  static Future<List<models.Movie>> fetchNowPlayingMovies() async {
    List<models.Movie> movies = [];
    String body = await request('now-playing');
    final moviesJson = jsonDecode(body);
    for (var movieJson in moviesJson['results']) {
      final movie = models.Movie.fromJson(movieJson);
      movies.add(movie);
    }
    return movies;
  }

  static Future<List<models.Movie>> fetchComingSoonMovies() async {
    List<models.Movie> movies = [];
    String body = await request('coming-soon');
    final moviesJson = jsonDecode(body);
    for (var movieJson in moviesJson['results']) {
      final movie = models.Movie.fromJson(movieJson);
      movies.add(movie);
    }
    return movies;
  }

  static Future<models.MovieDetail> fetchMovieDetail(int id) async {
    late models.MovieDetail movie;
    String body = await request('movie?id=$id');
    final movieJson = jsonDecode(body);
    movie = models.MovieDetail.fromJson(movieJson);
    return movie;
  }
}
