import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = _openDB();
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;
    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
    } else {
      isar.writeTxnSync(() => isar.movies.putSync(movie));
    }
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) async {
    final isar = await db;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  Future<Isar> _openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    return Isar.instanceNames.isEmpty
        ? await Isar.open([MovieSchema], inspector: true, directory: dir.path)
        : await Future.value(Isar.getInstance());
  }
}
