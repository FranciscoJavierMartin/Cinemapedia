import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/actor_themoviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actors_repository_impl.dart';

final actorRepositoryProvider = Provider<ActorsRepository>((ref) {
  return ActorsRespositoryImpl(ActorMovieDbDatasource());
});
