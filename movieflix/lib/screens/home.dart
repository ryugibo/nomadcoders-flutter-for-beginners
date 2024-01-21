import 'package:flutter/material.dart';
import 'package:movieflix/models/movie.dart' as model;
import 'package:movieflix/api/movie.dart' as api;
import 'package:movieflix/screens/detail.dart' as screen;

class Home extends StatelessWidget {
  Home({super.key});

  final Future<List<model.Movie>> popularMovies =
      api.Movie.fetchPopularMovies();
  final Future<List<model.Movie>> nowPlayingMovies =
      api.Movie.fetchNowPlayingMovies();
  final Future<List<model.Movie>> comingSoonMovies =
      api.Movie.fetchComingSoonMovies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.black.withOpacity(0.3),
        title: Row(
          children: [
            Icon(
              Icons.movie_filter,
              color: Colors.red.shade800,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Movieflix',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white.withOpacity(0.7),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            makeCategory(
              #popular,
              'Popular Movies',
              popularMovies,
              200,
              300,
            ),
            makeCategory(
              #nowPlaying,
              'Now in Cinemas',
              nowPlayingMovies,
              120,
              200,
              showTitle: true,
            ),
            makeCategory(
              #comingSoon,
              'Coming Soon',
              comingSoonMovies,
              120,
              200,
              showTitle: true,
            )
          ],
        ),
      ),
    );
  }

  Column makeCategory(Symbol symbol, String title,
      Future<List<model.Movie>> futureItems, double height, double width,
      {bool showTitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70),
            )
          ],
        ),
        SizedBox(
          height: height + 20 + (showTitle ? 20 : 0),
          child: FutureBuilder(
            future: futureItems,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return makeList(
                  symbol,
                  snapshot,
                  height,
                  width,
                  showTitle: showTitle,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ),
      ],
    );
  }

  ListView makeList(Symbol symbol, AsyncSnapshot<List<model.Movie>> snapshot,
      double height, double width,
      {bool showTitle = false}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        final movie = snapshot.data![index];

        precacheImage(
          Image.network(
            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          ).image,
          context,
        );

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen.Detail(
                  id: movie.id,
                  heroSymbol: symbol,
                  posterPath: movie.posterPath,
                ),
                // fullscreenDialog: true,
              ),
            );
          },
          child: Column(
            children: [
              Hero(
                tag: '$symbol${movie.id}',
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: width,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                  ),
                ),
              ),
              Visibility(
                visible: showTitle,
                child: SizedBox(
                  width: width,
                  height: 25,
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}
