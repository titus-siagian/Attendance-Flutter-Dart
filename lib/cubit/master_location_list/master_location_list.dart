import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/models/master_location.dart';
import 'package:ess_iris/repositories/master_location_repository.dart';
import 'package:ess_iris/services/response/error.dart';

class MasterLocationListCubit extends Cubit<ListState<MasterLocation>> {
  MasterLocationListCubit() : super(const ListState());

  final _repository = MasterLocationRepository();

  Future<void> getNearestLocation(double latitude, double longitude) async {
    emit(state.copyWith(status: ListStateStatus.loading));
    try {
      List<MasterLocation> response = await _repository.getMasterLocation(
        latitude,
        longitude,
      );

      emit(state.copyWith(status: ListStateStatus.success, data: response));
    } on DioError catch (e) {
      if (e.error is ErrorResponse) {
        emit(state.copyWith(status: ListStateStatus.failure, error: e.error));
      }
    }
  }
}
