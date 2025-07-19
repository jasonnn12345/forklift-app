
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/core/forklift_repository.dart';
import 'package:flutter_pos/data/forklift_response/delete_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/get_forklift_list_response.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:meta/meta.dart';

part 'forklift_index_state.dart';

class ForkliftIndexCubit extends Cubit<ForkliftIndexState> {
  ForkliftRepository forkliftRepository = ForkliftRepository();

  ForkliftIndexCubit() : super(ForkliftIndexInitial()) {
    getForkliftList();
  }

  void getForkliftList() async {
    emit(ForkliftIndexLoading());
    try {
      getForklistResponse result = await forkliftRepository.getAllForkliftList();
      debugPrint("Hasil ${result.forklift.length}");
      emit(ForkliftIndexLoaded(forklifts: result.forklift));
    } on DioError {
      emit(ForkliftIndexError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(ForkliftIndexError(message: e.toString()));
    }
  }

  void deleteForklift(int id) async {
    emit(ForkliftIndexLoading());
    try {
      await forkliftRepository.deleteForklift(id);
      getForkliftList();
    } on DioError {
      emit(ForkliftIndexError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(ForkliftIndexError(message: e.toString()));
    }
  }
}
