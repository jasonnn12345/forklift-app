import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/core/item_type_repository.dart';
import 'package:flutter_pos/data/index_response.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:meta/meta.dart';


part 'forklift_index_state.dart';

class ForkliftIndexCubit extends Cubit<ForkliftIndexState> {
ItemTypeRepository itemTypeRepository = ItemTypeRepository();

ForkliftIndexCubit() : super(ForkliftIndexInitial()) {
    index();
  }

  void index() async {
    emit(ForkliftIndexLoading());
    try {
      IndexResponse result = await itemTypeRepository.index();
      debugPrint("Hasil ${result.forklift.length}");
      emit(ForkliftIndexLoaded(forklifts: result.forklift));
    } on DioError {
      emit(ForkliftIndexError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(ForkliftIndexError(message: e.toString()));
    }
  }
}
