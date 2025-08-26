import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_app/features/trending_movies/data/models/movie_model.dart';
import 'package:the_movie_app/features/trending_movies/domain/repositories/trending_repository.dart';

abstract class TrendingLocalDataSource {
  Future<void> cacheTrendingMovies(
    TimeWindow timeWindow,
    int page,
    List<Map<String, dynamic>> rawMovies,
  );

  Future<List<MovieModel>?> getCachedTrendingMovies(
    TimeWindow timeWindow,
    int page, {
    Duration maxAge,
  });
}

class TrendingLocalDataSourceImpl implements TrendingLocalDataSource {

  TrendingLocalDataSourceImpl(this.prefs);
  static const String _prefix = 'trending_cache_';
  final SharedPreferences prefs;

  String _key(TimeWindow window, int page) => '$_prefix${window.name}_$page';
  String _tsKey(TimeWindow window, int page) => '${_key(window, page)}_ts';

  @override
  Future<void> cacheTrendingMovies(
    TimeWindow timeWindow,
    int page,
    List<Map<String, dynamic>> rawMovies,
  ) async {
    await prefs.setString(_key(timeWindow, page), jsonEncode(rawMovies));
    await prefs.setInt(_tsKey(timeWindow, page), DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<List<MovieModel>?> getCachedTrendingMovies(
    TimeWindow timeWindow,
    int page, {
    Duration maxAge = const Duration(minutes: 10),
  }) async {
    final ts = prefs.getInt(_tsKey(timeWindow, page));
    if (ts == null) return null;
    final fresh = DateTime.now().millisecondsSinceEpoch - ts < maxAge.inMilliseconds;
    if (!fresh) return null;
    final raw = prefs.getString(_key(timeWindow, page));
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final models = list.whereType<Map<String, dynamic>>().map<MovieModel>(MovieModel.fromJson).toList(growable: false);
      return models;
    } catch (_) {
      return null;
    }
  }
}
