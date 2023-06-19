import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recommendationsByMovieProvider = StateNotifierProvider<
    RecommendationsByMovieNotifier, Map<String, List<Movie>>>((ref) {
  final getRecommendations =
      ref.watch(movieRepositoryProvider).getRecommenedMovies;
  return RecommendationsByMovieNotifier(getRecommendations);
});

typedef GetRecommendationsCallback = Future<List<Movie>> Function(
    String movieId);

class RecommendationsByMovieNotifier
    extends StateNotifier<Map<String, List<Movie>>> {
  final GetRecommendationsCallback getRecommendations;

  RecommendationsByMovieNotifier(this.getRecommendations) : super({});

  Future<void> loadRecommendations(String movieId) async {
    if (state[movieId] == null) {
      final List<Movie> recommendedMovies = await getRecommendations(movieId);
      state = {...state, movieId: recommendedMovies};
    }
  }
}
