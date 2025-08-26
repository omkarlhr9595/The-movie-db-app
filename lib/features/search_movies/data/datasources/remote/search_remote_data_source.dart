import 'package:dio/dio.dart';
import 'package:the_movie_app/core/error/exceptions.dart';
import 'package:the_movie_app/core/network/dio_client.dart';
import 'package:the_movie_app/features/search_movies/data/datasources/local/search_local_data_source.dart';
import 'package:the_movie_app/features/trending_movies/data/models/movie_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<MovieModel>> searchMovies({required String query, required int page});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this._client, this._local);

  final DioClient _client;
  final SearchLocalDataSource _local;

  @override
  Future<List<MovieModel>> searchMovies({required String query, required int page}) async {
    const path = '/search/movie';
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        path,
        queryParameters: <String, dynamic>{
          'query': query,
          'page': page,
          'include_adult': false,
        },
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final results = response.data!['results'] as List<dynamic>? ?? <dynamic>[];
        final rawList = results.whereType<Map<String, dynamic>>().toList(growable: false);
        await _local.cacheSearchResults(query, page, rawList);
        final models = rawList.map<MovieModel>(MovieModel.fromJson).toList(growable: false);
        return models;
      }
      throw ServerException(message: 'Unexpected response', statusCode: response.statusCode);
    } on DioException catch (e) {
      _client.throwAsServerException(e);
    }
  }
}
