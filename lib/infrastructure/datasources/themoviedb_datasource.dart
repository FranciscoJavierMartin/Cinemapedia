import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/themoviedb_response.dart';

class TheMovieDBDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': 'en-US'
      }));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRates({int page = 1}) async {
    final response =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id not found');
    }

    final movieDetails = MovieDetails.fromJson(response.data);
    return MovieMapper.movieDetailsToEntity(movieDetails);
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    List<Movie> movies;

    if (query.isNotEmpty) {
      final response = await dio.get('/search/movie', queryParameters: {
        'query': query,
      });

      movies = _jsonToMovies(response.data);
    } else {
      movies = [];
    }

    return movies;
  }

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final theMovieDBResponse = TheMovieDbResponse.fromJson(json);
    final List<Movie> movies = theMovieDBResponse.results
        .where((theMovieDB) => theMovieDB.posterPath != '')
        .map((theMovieDB) => MovieMapper.theMovieDBToEntity(theMovieDB))
        .toList();

    return movies;
  }
}
