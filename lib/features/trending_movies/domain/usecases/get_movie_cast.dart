import 'package:cine_parker/core/result/result.dart';
import 'package:cine_parker/core/usecases/usecase.dart';
import 'package:cine_parker/features/trending_movies/domain/entities/cast_member.dart';
import 'package:cine_parker/features/trending_movies/domain/repositories/trending_repository.dart';

class GetMovieCastParams {
  const GetMovieCastParams(this.movieId);
  final int movieId;
}

class GetMovieCastUseCase implements UseCase<Result<List<CastMember>>, GetMovieCastParams> {
  GetMovieCastUseCase(this.repository);
  final TrendingRepository repository;

  @override
  Future<Result<List<CastMember>>> call(GetMovieCastParams params) {
    return repository.getMovieCast(params.movieId);
  }
}
