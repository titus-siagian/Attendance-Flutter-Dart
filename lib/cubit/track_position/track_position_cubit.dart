import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/services/response/error.dart';

class TrackPositionCubit extends Cubit<DetailState<Position>> {
  TrackPositionCubit() : super(const DetailState());

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    emit(state.copyWith(
      status: DetailStateStatus.loading,
    ));

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return emit(state.copyWith(
        status: DetailStateStatus.failure,
        error: ErrorResponse(
          message: 'Mohon aktifkan fitur lokasi pada ponsel anda!',
        ),
      ));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return emit(state.copyWith(
          status: DetailStateStatus.failure,
          error: ErrorResponse(
            message: 'Mohon izinkan akses lokasi pada ponsel anda!',
          ),
        ));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return emit(state.copyWith(
        status: DetailStateStatus.failure,
        error: ErrorResponse(
          message:
              'Tidak dapat mengakses lokasi secara permanen! aktifkan pada pengaturan ponsel anda.',
        ),
      ));
    }

    Position position = await Geolocator.getCurrentPosition();
    emit(state.copyWith(
      status: DetailStateStatus.success,
      data: position,
    ));
  }
}
