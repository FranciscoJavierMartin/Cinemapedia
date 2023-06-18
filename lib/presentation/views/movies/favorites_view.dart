import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final List<Movie> favoriteMovies =
        ref.watch(favoriteMoviesProvider).values.toList();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: favoriteMovies.isNotEmpty
          ? MovieMasonry(
              movies: favoriteMovies,
              loadNextPage: _loadNextPage,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline_sharp,
                      size: 60, color: colors.primary),
                  const Text(
                    'Try adding some movies',
                    style: TextStyle(fontSize: 20, color: Colors.black45),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.tonal(
                    onPressed: () => context.go('/home/0'),
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void _loadNextPage() async {
    if (!isLastPage && !isLastPage) {
      final List<Movie> movies =
          await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
      isLoading = false;

      if (movies.isEmpty) {
        isLastPage = true;
      }
    }
  }
}
