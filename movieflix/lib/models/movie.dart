class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        posterPath = json['poster_path'],
        backdropPath = json['backdrop_path'];
}
