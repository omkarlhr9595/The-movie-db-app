import 'package:the_movie_app/core/error/exceptions.dart';
import 'package:the_movie_app/core/error/failures.dart';
import 'package:the_movie_app/core/result/result.dart';
import 'package:the_movie_app/features/trending_movies/data/datasources/local/trending_local_data_source.dart';
import 'package:the_movie_app/features/trending_movies/data/datasources/remote/trending_remote_data_source.dart';
import 'package:the_movie_app/features/trending_movies/data/models/movie_model.dart';
import 'package:the_movie_app/features/trending_movies/domain/entities/cast_member.dart';
import 'package:the_movie_app/features/trending_movies/domain/entities/movie.dart';
import 'package:the_movie_app/features/trending_movies/domain/repositories/trending_repository.dart';

class TrendingRepositoryImpl implements TrendingRepository {
  TrendingRepositoryImpl(this.remoteDataSource, this.localDataSource);

  final TrendingRemoteDataSource remoteDataSource;
  final TrendingLocalDataSource localDataSource;

  @override
  Future<Result<List<Movie>>> getTrendingMovies(TimeWindow timeWindow, {required int page, bool forceRefresh = false}) async {
    try {
      final cached = forceRefresh ? null : await localDataSource.getCachedTrendingMovies(timeWindow, page);
      final models = cached ?? await remoteDataSource.getTrendingMovies(timeWindow, page: page);
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

  @override
  Future<Result<List<CastMember>>> getMovieCast(int movieId) async {
    try {
      final models = await remoteDataSource.getMovieCast(movieId);
      final cast = models.map((e) => e.toEntity()).toList(growable: false);
      return Success<List<CastMember>>(cast);
    } on ServerException catch (e) {
      return FailureResult<List<CastMember>>(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return FailureResult<List<CastMember>>(NetworkFailure(e.message));
    } catch (e) {
      return FailureResult<List<CastMember>>(ServerFailure(e.toString()));
    }
  }
}
