part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => <Object?>[];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading(this.query);
  final String query;
  @override
  List<Object?> get props => <Object?>[query];
}

class SearchFailure extends SearchState {
  const SearchFailure({required this.query, required this.message});
  final String query;
  final String message;
  @override
  List<Object?> get props => <Object?>[query, message];
}

class SearchSuccess extends SearchState {
  const SearchSuccess({required this.query, required this.movies, required this.page, required this.hasReachedMax, this.isLoadingMore = false});
  final String query;
  final List<Movie> movies;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;

  SearchSuccess copyWith({
    List<Movie>? movies,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return SearchSuccess(
      query: query,
      movies: movies ?? this.movies,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => <Object?>[query, movies, page, hasReachedMax, isLoadingMore];
}
