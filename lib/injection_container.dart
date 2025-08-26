import 'package:cine_parker/core/network/dio_client.dart';
import 'package:cine_parker/features/search_movies/data/datasources/local/search_local_data_source.dart';
import 'package:cine_parker/features/search_movies/data/datasources/remote/search_remote_data_source.dart';
import 'package:cine_parker/features/search_movies/data/repositories/search_repository_impl.dart';
import 'package:cine_parker/features/search_movies/domain/repositories/search_repository.dart';
import 'package:cine_parker/features/search_movies/domain/usecases/search_movies.dart';
import 'package:cine_parker/features/trending_movies/data/datasources/local/trending_local_data_source.dart';
import 'package:cine_parker/features/trending_movies/data/datasources/remote/trending_remote_data_source.dart';
import 'package:cine_parker/features/trending_movies/data/repositories/trending_repository_impl.dart';
import 'package:cine_parker/features/trending_movies/domain/repositories/trending_repository.dart';
import 'package:cine_parker/features/trending_movies/domain/usecases/get_movie_cast.dart';
import 'package:cine_parker/features/trending_movies/domain/usecases/get_trending_movies.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<DioClient>(DioClient.new);
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<SharedPreferences>(() => prefs)

    // Data sources
    ..registerLazySingleton<TrendingLocalDataSource>(() => TrendingLocalDataSourceImpl(sl()))
    ..registerLazySingleton<TrendingRemoteDataSource>(() => TrendingRemoteDataSourceImpl(sl(), sl()))
    ..registerLazySingleton<SearchLocalDataSource>(() => SearchLocalDataSourceImpl(sl()))
    ..registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(sl(), sl()))

    // Repositories
    ..registerLazySingleton<TrendingRepository>(() => TrendingRepositoryImpl(sl(), sl()))
    ..registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl(), sl()))

    // Use cases

    ..registerFactory<GetTrendingMoviesUseCase>(() => GetTrendingMoviesUseCase(sl()))
    ..registerFactory<GetMovieCastUseCase>(() => GetMovieCastUseCase(sl()))
    ..registerFactory<SearchMoviesUseCase>(() => SearchMoviesUseCase(sl()));

  // Blocs are created with BlocProvider near the UI instead of DI.
}
