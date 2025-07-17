import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/core/item_type_repository.dart';
import 'package:flutter_pos/data/index_response.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:meta/meta.dart';


part 'item_type_index_state.dart';

class ItemTypeIndexCubit extends Cubit<ItemTypeIndexState> {
ItemTypeRepository itemTypeRepository = ItemTypeRepository();

  ItemTypeIndexCubit() : super(ItemTypeIndexInitial()) {
    index();
  }

  void index() async {
    emit(ItemTypeIndexLoading());
    try {
      IndexResponse result = await itemTypeRepository.index();
      debugPrint("Hasil ${result.itemTypes.length}");
      emit(ItemTypeIndexLoaded(itemTypes: result.itemTypes));
    } on DioError {
      emit(ItemTypeIndexError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(ItemTypeIndexError(message: e.toString()));
    }
  }
}
