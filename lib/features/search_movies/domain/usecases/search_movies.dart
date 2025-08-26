import 'package:cine_parker/core/result/result.dart';
import 'package:cine_parker/core/usecases/usecase.dart';
import 'package:cine_parker/features/search_movies/domain/repositories/search_repository.dart';
import 'package:cine_parker/features/trending_movies/domain/entities/movie.dart';

class SearchMoviesParams {

  const SearchMoviesParams({required this.query, required this.page, this.forceRefresh = false});
  final String query;
  final int page;
  final bool forceRefresh;
}

class SearchMoviesUseCase implements UseCase<Result<List<Movie>>, SearchMoviesParams> {
  SearchMoviesUseCase(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<List<Movie>>> call(SearchMoviesParams params) {
    return repository.searchMovies(query: params.query, page: params.page, forceRefresh: params.forceRefresh);
  }
}
