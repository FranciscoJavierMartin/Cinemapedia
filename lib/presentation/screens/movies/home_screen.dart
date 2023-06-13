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
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return nowPlayingMovies.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const CustomAppBar(),
              MoviesSlideShow(movies: slideShowMovies),
              MoviesHorizontalListView(
                movies: nowPlayingMovies,
                title: 'Now in theaters',
                subtitle: 'What to watch',
                loadNextPage: () {
                  print('Hello from parent');
                },
              ),
            ],
          );
  }
}
