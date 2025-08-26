import 'package:the_movie_app/core/error/exceptions.dart';
import 'package:the_movie_app/core/error/failures.dart';
import 'package:the_movie_app/core/result/result.dart';
import 'package:the_movie_app/features/search_movies/data/datasources/local/search_local_data_source.dart';
import 'package:the_movie_app/features/search_movies/data/datasources/remote/search_remote_data_source.dart';
import 'package:the_movie_app/features/search_movies/domain/repositories/search_repository.dart';
import 'package:the_movie_app/features/trending_movies/data/models/movie_model.dart';
import 'package:the_movie_app/features/trending_movies/domain/entities/movie.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this.remote, this.local);

  final SearchRemoteDataSource remote;
  final SearchLocalDataSource local;

  @override
  Future<Result<List<Movie>>> searchMovies({required String query, required int page, bool forceRefresh = false}) async {
    try {
      final cached = forceRefresh ? null : await local.getCachedSearchResults(query, page);
      final models = cached ?? await remote.searchMovies(query: query, page: page);
      final movies = models.map((MovieModel m) => m.toEntity()).toList(growable: false);
      
      // Remove duplicates based on movie ID to prevent Hero tag conflicts
      final uniqueMovies = <int, Movie>{};
      for (final movie in movies) {
        uniqueMovies[movie.id] = movie;
      }
      final deduplicatedMovies = uniqueMovies.values.toList(growable: false);
      
      return Success<List<Movie>>(deduplicatedMovies);
    } on ServerException catch (e) {
      return FailureResult<List<Movie>>(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult<List<Movie>>(NetworkFailure(e.message));
    } catch (e) {
      return FailureResult<List<Movie>>(ServerFailure(e.toString()));
    }
  }
}
