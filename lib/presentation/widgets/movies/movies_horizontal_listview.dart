import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesHorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MoviesHorizontalListView({
    super.key,
    required this.movies,
    this.title,
    this.subtitle,
    this.loadNextPage,
  });

  @override
  State<MoviesHorizontalListView> createState() =>
      _MoviesHorizontalListViewState();
}

class _MoviesHorizontalListViewState extends State<MoviesHorizontalListView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage != null) {
        if ((scrollController.position.pixels + 200) >=
            scrollController.position.maxScrollExtent) {
          print('Load next movies');
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(
              title: widget.title,
              subtitle: widget.subtitle,
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _Slide(
                  movie: widget.movies[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        if (title != null)
          Text(
            title!,
            style: titleStyle,
          ),
        const Spacer(),
        if (subtitle != null)
          FilledButton.tonal(
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
            onPressed: () {},
            child: Text(subtitle!),
          ),
      ]),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  final double width;

  const _Slide({required this.movie, this.width = 150});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: width,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress != null
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : FadeIn(child: child),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: width,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyles.titleSmall,
            ),
          ),
          SizedBox(
            width: width,
            child: Row(
              children: [
                Icon(
                  Icons.star_half_outlined,
                  color: Colors.yellow.shade800,
                ),
                const SizedBox(width: 3),
                Text(
                  '${movie.voteAverage}',
                  style: textStyles.bodyMedium
                      ?.copyWith(color: Colors.yellow.shade800),
                ),
                const Spacer(),
                Text(
                  HumanFormats.number(movie.popularity),
                  style: textStyles.bodySmall,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
