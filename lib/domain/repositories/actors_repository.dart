import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/actor_biography.dart';

abstract class ActorsRepository {
  Future<List<Actor>> getActorsByMovie(String movieId);
  Future<ActorBiography> getActorById(String actorId);
}
