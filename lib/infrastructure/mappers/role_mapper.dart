import 'package:cinemapedia/domain/entities/role.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/roles_response.dart';

class RoleMapper {
  static Role roleToEntity(Cast role) => Role(
        backdropPath: role.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500${role.backdropPath}'
            : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
        id: role.id,
        posterPath: role.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500${role.posterPath}'
            : 'https://www.movienewz.com/img/films/poster-holder.jpg',
        title: role.title,
        voteAverage: role.voteAverage,
        character: role.character ?? '',
      );
}
