import 'package:cinemapedia/domain/entities/entities.dart';

abstract class ActorsDatasource {
  Future<List<Actor>> getActorsByMovie(String movieId);
  Future<ActorBiography> getActorById(String actorId);
  Future<List<Role>> getRolesByActor(String actorId);
}
