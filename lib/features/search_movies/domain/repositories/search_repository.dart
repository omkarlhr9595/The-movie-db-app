import 'package:the_movie_app/core/result/result.dart';
import 'package:the_movie_app/features/trending_movies/domain/entities/movie.dart';

abstract class SearchRepository {
  Future<Result<List<Movie>>> searchMovies({required String query, required int page, bool forceRefresh = false});
}
