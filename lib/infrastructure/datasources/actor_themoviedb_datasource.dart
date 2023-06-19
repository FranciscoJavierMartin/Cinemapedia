import 'package:cinemapedia/domain/entities/actor_biography.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/actors_response.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/credits_response.dart';

class ActorMovieDbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'en-US'
      }));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    final castResponse = CreditsResponse.fromJson(response.data);

    return castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();
  }

  @override
  Future<ActorBiography> getActorById(String actorId) async {
    final response = await dio.get('/person/$actorId');
    final actorResponse = ActorBiographyResponse.fromJson(response.data);
    return ActorMapper.castToActorBiographyEntity(actorResponse);
  }
}
