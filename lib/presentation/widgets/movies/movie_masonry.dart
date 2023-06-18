import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.loadNextPage != null) {
      scrollController.addListener(() {
        if ((scrollController.position.pixels + 100) >=
            scrollController.position.maxScrollExtent) {
          widget.loadNextPage!();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.loadNextPage != null) {
      scrollController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        controller: scrollController,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) => index == 1
            ? Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  MoviePosterLink(movie: widget.movies[index])
                ],
              )
            : MoviePosterLink(movie: widget.movies[index]),
      ),
    );
  }
}
