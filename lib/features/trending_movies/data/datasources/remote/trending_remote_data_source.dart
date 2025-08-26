import 'package:cine_parker/core/error/exceptions.dart';
import 'package:cine_parker/core/network/dio_client.dart';
import 'package:cine_parker/features/trending_movies/data/datasources/local/trending_local_data_source.dart';
import 'package:cine_parker/features/trending_movies/data/models/cast_member_model.dart';
import 'package:cine_parker/features/trending_movies/data/models/movie_model.dart';
import 'package:cine_parker/features/trending_movies/domain/repositories/trending_repository.dart';
import 'package:dio/dio.dart';

/// Abstract class for the trending remote data source
abstract class TrendingRemoteDataSource {
  /// Get trending movies
  Future<List<MovieModel>> getTrendingMovies(
    TimeWindow timeWindow, {
    required int page,
  });

  /// Get movie cast
  Future<List<CastMemberModel>> getMovieCast(int movieId);
}

/// Implementation of the trending remote data source
class TrendingRemoteDataSourceImpl implements TrendingRemoteDataSource {
  /// Constructor for the TrendingRemoteDataSourceImpl
  TrendingRemoteDataSourceImpl(this._client, this._local);

  /// Dio client
  final DioClient _client;

  /// Trending local data source
  final TrendingLocalDataSource _local;

  /// Get trending movies
  @override
  Future<List<MovieModel>> getTrendingMovies(
    TimeWindow timeWindow, {
    required int page,
  }) async {
    final path = '/trending/movie/${timeWindow == TimeWindow.day ? 'day' : 'week'}';
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        path,
        queryParameters: <String, dynamic>{'page': page},
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final results = response.data!['results'] as List<dynamic>? ?? <dynamic>[];
        final rawList = results.whereType<Map<String, dynamic>>().toList(growable: false);
        await _local.cacheTrendingMovies(timeWindow, page, rawList);
        final models = rawList.map<MovieModel>(MovieModel.fromJson).toList(growable: false);
        return models;
      }
      throw ServerException(message: 'Unexpected response', statusCode: response.statusCode);
    } on DioException catch (e) {
      _client.throwAsServerException(e);
    }
  }

  @override
  Future<List<CastMemberModel>> getMovieCast(int movieId) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/movie/$movieId/credits');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final results = response.data!['cast'] as List<dynamic>? ?? <dynamic>[];
        return results.whereType<Map<String, dynamic>>().map<CastMemberModel>(CastMemberModel.fromJson).toList(growable: false);
      }
      throw ServerException(message: 'Unexpected response', statusCode: response.statusCode);
    } on DioException catch (e) {
      _client.throwAsServerException(e);
    }
  }
}
