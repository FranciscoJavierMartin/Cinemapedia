import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorsRespositoryImpl extends ActorsRepository {
  final ActorsDatasource datasource;

  ActorsRespositoryImpl(this.datasource);

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }

  @override
  Future<ActorBiography> getActorById(String actorId) {
    return datasource.getActorById(actorId);
  }

  @override
  Future<List<Role>> getRolesByActor(String actorId) {
    return datasource.getRolesByActor(actorId);
  }
}
