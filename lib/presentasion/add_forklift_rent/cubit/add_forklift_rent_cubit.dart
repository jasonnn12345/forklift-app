import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/forklift_rent_repository.dart';
import 'package:meta/meta.dart';

part 'add_forklift_rent_state.dart';

class AddRentCubit extends Cubit<AddRentState> {
  final forkliftRentRepository = ForkliftRentRepository();

  AddRentCubit() : super(AddRentInitial());

  void createForkliftRent({
    required int penyewaId,
    required int forkliftId,
    required String tanggalSewa,
    required int lamaSewa,
    required int totalBiaya,
  }) async {
    emit(AddRentLoading());
    try {
      final params = {
        "id_penyewa": penyewaId,
        "id_forklift": forkliftId,
        "tanggal_sewa": tanggalSewa,
        "lama_sewa": lamaSewa,
        "total_biaya": totalBiaya,
      };

      final result = await forkliftRentRepository.create(params);
      emit(AddRentSuccess(message: result.message));
    } on DioError catch (_) {
      emit(AddRentError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddRentError(message: e.toString()));
    }
  }

  void editForkliftRent({
    required int id,
    required int penyewaId,
    required int forkliftId,
    required String tanggalSewa,
    required int lamaSewa,
    required int totalBiaya,
  }) async {
    emit(AddRentLoading());
    try {
      final params = {
        "id_penyewa": penyewaId,
        "id_forklift": forkliftId,
        "tanggal_sewa": tanggalSewa,
        "lama_sewa": lamaSewa,
        "total_biaya": totalBiaya,
      };

      final result = await forkliftRentRepository.updateForklift(id,params);
      emit(AddRentSuccess(message: result.message));
    } on DioError catch (_) {
      emit(AddRentError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddRentError(message: e.toString()));
    }
  }
}