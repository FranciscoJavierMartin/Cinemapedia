import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

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

    return Scaffold(
      body: MovieMasonry(
        movies: favoriteMovies,
        loadNextPage: _loadNextPage,
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
