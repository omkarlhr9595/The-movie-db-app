import 'package:the_movie_app/core/result/result.dart';
import 'package:the_movie_app/features/trending_movies/domain/entities/cast_member.dart';
import 'package:the_movie_app/features/trending_movies/domain/entities/movie.dart';

enum TimeWindow { day, week }

abstract class TrendingRepository {
  Future<Result<List<Movie>>> getTrendingMovies(TimeWindow timeWindow, {required int page, bool forceRefresh = false});
  Future<Result<List<CastMember>>> getMovieCast(int movieId);
}
