import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/item_type_repository.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:meta/meta.dart';

part 'add_item_state.dart';

class AddItemCubit extends Cubit<AddItemState> {
  final itemTypeRepository = ItemTypeRepository();

  AddItemCubit() : super(AddItemInitial());

  void submit(String code, String name, String status) async {
    emit(AddItemLoading());
    try {
      final params = {"name": name, "code": code, "status": status};
      final result = await itemTypeRepository.create(params);

      emit(AddItemSuccess(message: result.message));
    } on DioError catch (_){
      emit(AddItemError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(AddItemError(message: e.toString()));
    }
  }
}
