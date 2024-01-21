class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final double vote;
  final List<String> genres;

  MovieDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        overview = json['overview'],
        vote = json['vote_average'],
        genres = json['genres']
            .map((genre) => genre['name'])
            .toList()
            .cast<String>();
}
