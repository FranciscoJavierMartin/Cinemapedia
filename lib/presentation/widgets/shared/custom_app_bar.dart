import 'package:cinemapedia/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium;
    final bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(children: [
            Icon(Icons.movie_outlined, color: colors.primary),
            const SizedBox(width: 5),
            Text('Cinemapedia', style: titleStyle),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                final List<Movie> searchedMovies =
                    ref.read(searchedMoviesProvider);
                final String searchQuery = ref.read(searchQueryProvider);

                showSearch<Movie?>(
                  query: searchQuery,
                  context: context,
                  delegate: SearchMovieDelegate(
                    initialMovies: searchedMovies,
                    searchMovies: ref
                        .read(searchedMoviesProvider.notifier)
                        .searchMoviesByQuery,
                  ),
                ).then(
                  (movie) {
                    if (movie != null) {
                      goToMoviePage(context, movie.id);
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(
                isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: () {
                ref.read(themeNotifierProvider.notifier).toggleDarkMode();
              },
            )
          ]),
        ),
      ),
    );
  }
}
