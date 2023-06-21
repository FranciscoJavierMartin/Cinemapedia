import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb/themoviedb_videos_response.dart';

class VideoMapper {
  static theMovieDBVideoToEntity(Result video) => Video(
        id: video.id,
        name: video.name,
        youtubeKey: video.key,
        publishedAt: video.publishedAt,
      );
}
