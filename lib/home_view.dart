import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel_ui_flutter/details_screen.dart';
import 'package:travel_ui_flutter/models/movie.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late List<Movie> data = [];
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    getVideo();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void getVideo() async {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'language': 'en-US'},
      headers: {
        "accept": 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MzdhOGYzNmUyNjhiODZlM2YyMGE1N2Y2NmNjYmY3OCIsInN1YiI6IjY0ZjU1MDNhOTdhNGU2MjU5ZGM0YjQ0ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JL8MZq53VMZzF7S3xrJqqlZf3Pf0O-AqvH5HoAFMqbM',
      },
    ));

    final res = await dio.get(
      '/movie/popular',
      queryParameters: {'page': 1},
    );
    final List listMovie = res.data['results'];
    final List<Movie> movies = listMovie
        .map((e) => Movie(
              adult: e["adult"],
              backdropPath: e["backdrop_path"] != '' ||
                      e["backdrop_path"] != null
                  ? 'https://image.tmdb.org/t/p/w500${e['backdrop_path']}'
                  : "https://www.reelviews.net/resources/img/default_poster.jpg",
              genreIds:
                  List<String>.from(e["genre_ids"].map((x) => x.toString())),
              id: e["id"],
              originalLanguage: e["original_language"],
              originalTitle: e["original_title"],
              overview: e["overview"],
              popularity: e["popularity"],
              posterPath: e["poster_path"] != '' || e["poster_path"] != null
                  ? 'https://image.tmdb.org/t/p/w500${e['poster_path']}'
                  : "https://www.reelviews.net/resources/img/default_poster.jpg",
              releaseDate: DateTime.now(),
              title: e["title"],
              video: e["video"],
              voteAverage: 0.0,
              voteCount: e["vote_count"],
            ))
        .toList();

    setState(() {
      data = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FadeTransition(
                        opacity: animation,
                        child: DetailsScreen(item: item),
                      ),
                    ),
                  );
                },
                child: _Item(item: item),
              );
            },
          ),
        )
      ],
    ));
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.item});

  final Movie item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: NetworkImage(item.posterPath),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Colors.black26,
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // avatar
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white54, width: 3),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(item.posterPath),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  FadeTransition(
                            opacity: animation,
                            child: DetailsScreen(item: item),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Button Test",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              // text

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    TextButton.icon(
                      // style: ButtonStyle(
                      //   shape: MaterialStateProperty.all<
                      //       RoundedRectangleBorder>(
                      //     RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(90),
                      //         side: const BorderSide(
                      //             color: Colors.red)),
                      //   ),
                      // ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        size: 24.0,
                        color: Colors.white,
                      ),
                      label: const Text(
                        '123',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        size: 24.0,
                        color: Colors.white,
                      ),
                      label: const Text(
                        '123',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
