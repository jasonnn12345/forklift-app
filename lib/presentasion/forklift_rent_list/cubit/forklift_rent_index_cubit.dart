
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

  Future<void> confirmAndDelete(BuildContext context, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Penyewaan'),
        content: Text('Yakin ingin menghapus penyewaan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await deleteForklift(id);
    }
  }

  Future<void> deleteForklift(int id) async {
    try {
      emit(ForkliftRentIndexLoading());
      await forkliftRentRepository.deleteForklift(id);
      getAllForkliftRentList(); // Refresh list setelah delete
    } catch (e) {
      emit(ForkliftRentIndexError(message: "Gagal menghapus penyewaan"));
    }
  }

}
