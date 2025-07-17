import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/item_type_repository.dart';
import 'package:meta/meta.dart';

part 'edit_item_state.dart';

class EditItemCubit extends Cubit<EditItemState> {
  final itemTypeRepository = ItemTypeRepository();
  EditItemCubit() : super(EditItemInitial());

  void update(int id, String name, String code, String status) async {
    emit(EditItemLoading() as EditItemState);
    try {
      final params = {"name": name, "code": code, "status": status};
      final result =  await itemTypeRepository.update(id, params);
      emit(EditItemSuccess(message: result.message));
    } on DioError catch (_) {
      emit(EditItemError(message: "Masalah Koneksi"));
    } catch(e) {
      emit(EditItemError(message: e.toString()));
    }
  }
}
