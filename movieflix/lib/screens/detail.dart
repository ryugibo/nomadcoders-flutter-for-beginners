import 'package:flutter/material.dart';
import 'package:movieflix/api/movie.dart' as api;
import 'package:movieflix/models/movie_detail.dart' as model;

class Detail extends StatefulWidget {
  final int id;
  final Symbol heroSymbol;
  final String posterPath;

  const Detail({
    super.key,
    required this.id,
    required this.heroSymbol,
    required this.posterPath,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<model.MovieDetail> movieDetail;

  @override
  void initState() {
    super.initState();
    movieDetail = api.Movie.fetchMovieDetail(widget.id);
  }

  List<Container> _buildGenres(List<String> genres) {
    return List.generate(genres.length, (index) {
      return Container(
        margin: (index == (genres.length - 1))
            ? EdgeInsets.zero
            : const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade900.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          genres[index],
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      );
    });
  }

  List<Icon> _buildStars(double vote) {
    return List.generate(5, (index) {
      var voteInt = vote ~/ 2;
      return Icon(
        voteInt < index
            ? Icons.star_border_rounded
            : voteInt == index && vote % 2 > 0
                ? Icons.star_half_rounded
                : Icons.star_rate_rounded,
        color: (voteInt >= index) ? Colors.yellow.shade700 : Colors.white38,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: movieDetail,
        builder: (context, snapshot) {
          var detail = snapshot.hasData ? snapshot.data! : null;
          return Hero(
            tag: '${widget.heroSymbol}${widget.id}',
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                  image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500${widget.posterPath}',
                  ),
                ),
              ),
              child: detail == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ..._buildStars(detail.vote),
                              const SizedBox(width: 5),
                              Text(
                                '${detail.vote.toStringAsFixed(1)}/10',
                                style: const TextStyle(
                                  color: Colors.white38,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            child: Row(
                              children: _buildGenres(
                                detail.genres,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book,
                                    color: Colors.white60,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Storyline',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 25,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                detail.overview,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 120,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
