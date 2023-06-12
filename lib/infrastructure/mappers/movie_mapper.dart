import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/movie_themoviedb.dart';

class MovieMapper {
  static Movie theMovieDBToEntity(MovieTheMovieDB theMovieDB) => Movie(
        adult: theMovieDB.adult,
        backdropPath: theMovieDB.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500${theMovieDB.backdropPath}'
            : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
        genreIds: theMovieDB.genreIds.map((e) => e.toString()).toList(),
        id: theMovieDB.id,
        originalLanguage: theMovieDB.originalLanguage,
        originalTitle: theMovieDB.originalTitle,
        overview: theMovieDB.overview,
        popularity: theMovieDB.popularity,
        posterPath: theMovieDB.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500${theMovieDB.posterPath}'
            : '',
        releaseDate: theMovieDB.releaseDate,
        title: theMovieDB.title,
        video: theMovieDB.video,
        voteAverage: theMovieDB.voteAverage,
        voteCount: theMovieDB.voteCount,
      );
}
