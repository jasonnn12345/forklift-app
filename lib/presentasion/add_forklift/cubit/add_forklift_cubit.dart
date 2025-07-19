
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/forklift_repository.dart';
import 'package:flutter_pos/core/item_type_repository.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:meta/meta.dart';

part 'add_forklift_state.dart';

class AddForkliftCubit extends Cubit<AddItemState> {
  final forkliftRepository = ForkliftRepository();

  AddForkliftCubit() : super(AddItemInitial());

  void submit(String merk, String capacity, int price) async {
    emit(AddItemLoading());
    try {
      final params = {"merk_forklift": merk, "kapasitas_forklift": capacity, "harga_sewa": price};
      final result = await forkliftRepository.create(params);

      emit(AddItemSuccess(message: result.message));
    } on DioError catch (_){
      emit(AddItemError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddItemError(message: e.toString()));
    }
  }
}
