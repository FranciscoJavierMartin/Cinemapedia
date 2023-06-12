import 'package:cinemapedia/infrastructure/datasources/themoviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movies_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider((ref) {
  return MoviesRepositoryImpl(TheMovieDBDatasource());
});
