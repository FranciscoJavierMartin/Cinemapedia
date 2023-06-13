import 'package:cinemapedia/presentation/widgets/movies/movies_horizontal_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatesMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatesMovies = ref.watch(topRatesMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return nowPlayingMovies.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
            slivers: [
              const SliverAppBar(
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: CustomAppBar(),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      children: [
                        MoviesSlideShow(movies: slideShowMovies),
                        MoviesHorizontalListView(
                          movies: nowPlayingMovies,
                          title: 'Now playing',
                          subtitle: 'What to watch',
                          loadNextPage: () => ref
                              .read(nowPlayingMoviesProvider.notifier)
                              .loadNextPage(),
                        ),
                        MoviesHorizontalListView(
                          movies: nowPlayingMovies,
                          title: 'Upcoming',
                          loadNextPage: () => ref
                              .read(nowPlayingMoviesProvider.notifier)
                              .loadNextPage(),
                        ),
                        MoviesHorizontalListView(
                          movies: popularMovies,
                          title: 'Popular',
                          loadNextPage: () => ref
                              .read(popularMoviesProvider.notifier)
                              .loadNextPage(),
                        ),
                        MoviesHorizontalListView(
                          movies: topRatesMovies,
                          title: 'Top rated',
                          loadNextPage: () => ref
                              .read(topRatesMoviesProvider.notifier)
                              .loadNextPage(),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          );
  }
}
