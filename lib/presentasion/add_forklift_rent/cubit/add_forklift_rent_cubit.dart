import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/forklift_rent_repository.dart';
import 'package:meta/meta.dart';

part 'add_forklift_rent_state.dart';

class AddPenyewaanCubit extends Cubit<AddItemState> {
  final forkliftRentRepository = ForkliftRentRepository();

  AddPenyewaanCubit() : super(AddItemInitial());

  void createForkliftRent({
    required int penyewaId,
    required int forkliftId,
    required String tanggalSewa,
    required String tanggalKembali,
    required int lamaSewa,
    required int totalBiaya,
  }) async {
    emit(AddItemLoading());
    try {
      final params = {
        "id_penyewa": penyewaId,
        "id_forklift": forkliftId,
        "tanggal_sewa": tanggalSewa,
        "tanggal_kembali": tanggalKembali,
        "lama_sewa": lamaSewa,
        "total_biaya": totalBiaya,
      };

      final result = await forkliftRentRepository.create(params);
      emit(AddItemSuccess(message: result.message));
    } on DioError catch (_) {
      emit(AddItemError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddItemError(message: e.toString()));
    }
  }
}
