
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/core/forklift_rent_repository.dart';
import 'package:flutter_pos/core/forklift_repository.dart';
import 'package:flutter_pos/data/forklift_rent_response/get_forklift_rent_list_response.dart';
import 'package:flutter_pos/data/forklift_response/delete_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/get_forklift_list_response.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/data/model/forklift_rent_data.dart';
import 'package:meta/meta.dart';

part 'forklift_rent_index_state.dart';

class ForkliftRentIndexCubit extends Cubit<ForkliftRentIndexState> {
  ForkliftRentRepository forkliftRentRepository = ForkliftRentRepository();

  ForkliftRentIndexCubit() : super(ForkliftRentIndexInitial()) {
    getAllForkliftRentList();
  }

  void getAllForkliftRentList() async {
    emit(ForkliftRentIndexLoading());
    try {
      getForklistRentResponse result = await forkliftRentRepository.getAllForkliftRentList();
      emit(ForkliftRentIndexLoaded(forkliftRent: result.forkliftRent));
    } on DioError {
      emit(ForkliftRentIndexError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(ForkliftRentIndexError(message: e.toString()));
    }
  }
}
