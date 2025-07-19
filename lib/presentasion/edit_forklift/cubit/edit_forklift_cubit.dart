import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/forklift_repository.dart';
import 'package:meta/meta.dart';

part 'edit_forklift_state.dart';

class EditForkliftCubit extends Cubit<EditForkliftState> {
  final forkliftRepository = ForkliftRepository();
  EditForkliftCubit() : super(EditForkliftInitial());

  void update(int id,String merk, String capacity, int price) async {
    emit(EditForkliftLoading() as EditForkliftState);
    try {
      final params = {"merk_forklift": merk, "kapasitas_forklift": capacity, "harga_sewa": price};
      final result =  await forkliftRepository.updateForklift(id, params);
      emit(EditForkliftSuccess(message: result.message));
    } on DioError catch (_) {
      emit(EditForkliftError(message: "Masalah Koneksi"));
    } catch(e) {
      emit(EditForkliftError(message: e.toString()));
    }
  }
}
