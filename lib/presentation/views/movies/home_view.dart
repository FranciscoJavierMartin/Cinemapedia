import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatesMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget res;
    final initialLoading = ref.watch<bool>(initialLoadingprovider);

    if (initialLoading) {
      res = const FullScreenLoader();
    } else {
      final nowPlayingMovies = ref.watch<List<Movie>>(nowPlayingMoviesProvider);
      final popularMovies = ref.watch<List<Movie>>(popularMoviesProvider);
      final topRatesMovies = ref.watch<List<Movie>>(topRatesMoviesProvider);
      final upcomingMovies = ref.watch<List<Movie>>(upcomingMoviesProvider);
      final slideShowMovies = ref.watch<List<Movie>>(moviesSlideshowProvider);

      res = CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: CustomAppBar(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                return Column(
                  children: [
                    MoviesSlideShow(movies: slideShowMovies),
                    MoviesHorizontalListView(
                      movies: nowPlayingMovies,
                      title: AppLocalizations.of(context)!.nowPlaying,
                      subtitle: AppLocalizations.of(context)!.whatToWatch,
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MoviesHorizontalListView(
                      movies: upcomingMovies,
                      title: AppLocalizations.of(context)!.upcoming,
                      loadNextPage: () => ref
                          .read(upcomingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MoviesHorizontalListView(
                      movies: popularMovies,
                      title: AppLocalizations.of(context)!.popular,
                      loadNextPage: () => ref
                          .read(popularMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MoviesHorizontalListView(
                      movies: topRatesMovies,
                      title: AppLocalizations.of(context)!.topRated,
                      loadNextPage: () => ref
                          .read(topRatesMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }

    return res;
  }
}
