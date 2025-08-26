part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => <Object?>[];
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => <Object?>[query];
}

class SearchRequested extends SearchEvent {
  const SearchRequested(this.query);
  final String query;
  @override
  List<Object?> get props => <Object?>[query];
}

class SearchLoadMoreRequested extends SearchEvent {
  const SearchLoadMoreRequested();
}
