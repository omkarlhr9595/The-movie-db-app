import 'package:cine_parker/features/trending_movies/domain/entities/cast_member.dart';
import 'package:cine_parker/features/trending_movies/domain/usecases/get_movie_cast.dart';
import 'package:cine_parker/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cast_state.dart';

class CastCubit extends Cubit<CastState> {
  CastCubit() : super(const CastState.initial());

  final GetMovieCastUseCase _getMovieCast = sl<GetMovieCastUseCase>();

  Future<void> load(int movieId) async {
    emit(const CastState.loading());
    try {
      final result = await _getMovieCast(GetMovieCastParams(movieId));
      result.when(
        success: (data) => emit(CastState.success(data)),
        failure: (f) => emit(CastState.failure(f.message)),
      );
    } catch (e) {
      emit(CastState.failure(e.toString()));
    }
  }
}
