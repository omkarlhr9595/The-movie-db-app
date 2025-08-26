part of 'trending_bloc.dart';

abstract class TrendingEvent extends Equatable {
  const TrendingEvent();
  @override
  List<Object?> get props => <Object?>[];
}

class TrendingRequestedEvent extends TrendingEvent {
  const TrendingRequestedEvent();
}

class TrendingHardRefreshRequestedEvent extends TrendingEvent {
  const TrendingHardRefreshRequestedEvent();
}

class TrendingLoadMoreRequestedEvent extends TrendingEvent {
  const TrendingLoadMoreRequestedEvent();
}

class TrendingTimeWindowChangedEvent extends TrendingEvent {
  const TrendingTimeWindowChangedEvent(this.timeWindow);
  final TimeWindow timeWindow;

  @override
  List<Object?> get props => <Object?>[timeWindow];
}

class TrendingCastRequestedEvent extends TrendingEvent {
  const TrendingCastRequestedEvent(this.movieId);
  final int movieId;

  @override
  List<Object?> get props => <Object?>[movieId];
}
