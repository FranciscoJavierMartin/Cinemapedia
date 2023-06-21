import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref
        .read(recommendationsByMovieProvider.notifier)
        .loadRecommendations(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    return movie == null
        ? const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Scaffold(
            body: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                _CustomSliverAppBar(movie: movie),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(movie: movie),
                  childCount: 1,
                )),
              ],
            ),
          );
  }
}

final isFavoriteProvider = FutureProvider.family((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final AsyncValue<bool> isFavoriteFuture =
        ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite
                ? const Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                  ),
            error: (_, __) => const Icon(
              Icons.favorite_border,
            ),
            loading: () => const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress != null ? const SizedBox() : child,
              ),
            ),
            const CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [Colors.black54, Colors.transparent],
            ),
            const CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [Colors.transparent, Colors.black87],
            ),
            const CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [Colors.black87, Colors.transparent],
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  children: [
                    Text(
                      movie.title,
                      style: textStyles.titleLarge,
                    ),
                    Text(movie.overview),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(children: [
            ...movie.genreIds.map((genre) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(genre),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ))
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Casting', style: textStyles.titleLarge),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
        VideoTrailer(movieId: movie.id),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('If you like, try this', style: textStyles.titleLarge),
        ),
        _RecommendationsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    return actorsByMovie[movieId] == null
        ? const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: actorsByMovie[movieId]!.length,
              itemBuilder: (context, index) {
                final Actor actor = actorsByMovie[movieId]![index];

                return GestureDetector(
                  onTap: () => context.push('/home/0/actor/${actor.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: 135,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            actor.profilePath,
                            height: 180,
                            width: 135,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          actor.name,
                          maxLines: 2,
                        ),
                        Text(actor.character ?? '',
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class _RecommendationsByMovie extends ConsumerWidget {
  final String movieId;

  const _RecommendationsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsByMovie = ref.watch(recommendationsByMovieProvider);

    return recommendationsByMovie[movieId] == null
        ? const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendationsByMovie[movieId]?.length ?? 0,
              itemBuilder: (context, index) {
                final Movie movie = recommendationsByMovie[movieId]![index];
                return GestureDetector(
                  onTap: () => context.push('/home/0/movie/${movie.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: 135,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            movie.posterPath,
                            height: 180,
                            width: 135,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(movie.title, maxLines: 2)
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
