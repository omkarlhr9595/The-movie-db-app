import 'package:the_movie_app/core/result/result.dart';
import 'package:the_movie_app/core/usecases/usecase.dart';
import 'package:the_movie_app/features/trending_movies/domain/entities/movie.dart';
import 'package:the_movie_app/features/trending_movies/domain/repositories/trending_repository.dart';

class GetTrendingMoviesParams {

  const GetTrendingMoviesParams({required this.timeWindow, required this.page, this.forceRefresh = false});
  final TimeWindow timeWindow;
  final int page;
  final bool forceRefresh;
}

class GetTrendingMoviesUseCase implements UseCase<Result<List<Movie>>, GetTrendingMoviesParams> {

  GetTrendingMoviesUseCase(this.repository);
  final TrendingRepository repository;

  @override
  Future<Result<List<Movie>>> call(GetTrendingMoviesParams params) {
    return repository.getTrendingMovies(params.timeWindow, page: params.page, forceRefresh: params.forceRefresh);
  }
}
