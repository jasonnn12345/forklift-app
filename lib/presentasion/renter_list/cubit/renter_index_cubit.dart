
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/core/forklift_repository.dart';
import 'package:flutter_pos/core/renter_repository.dart';
import 'package:flutter_pos/data/forklift_response/delete_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/get_forklift_list_response.dart';
import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/data/model/renter_data.dart';
import 'package:flutter_pos/data/renter_response/get_renter_list_response.dart';
import 'package:flutter_pos/presentasion/add_forklift/cubit/add_forklift_cubit.dart';
import 'package:meta/meta.dart';

part 'renter_index_state.dart';

class RenterIndexCubit extends Cubit<RenterIndexState> {
  RenterRepository renterRepository = RenterRepository();

  RenterIndexCubit() : super(RenterIndexInitial()) {
    getRenterList();
  }

  void getRenterList() async {
    emit(RenterIndexLoading());
    try {
      GetRenterResponse result = await renterRepository.getAllRenterList();
      emit(RenterIndexLoaded(renterList: result.renter));
    } on DioError {
      emit(RenterIndexError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(RenterIndexError(message: e.toString()));
    }
  }

  void deleteRenter(int id) async {
    emit(RenterIndexLoading());
    try {
      await renterRepository.deleteRenter(id);
      getRenterList();
    } on DioError {
      emit(RenterIndexError(message: "Server tidak terhubung"));
    } catch (e) {
      emit(RenterIndexError(message: e.toString()));
    }
  }

  void createRenter({
    required String namaPenyewa,
    required String noTelp,
    required String alamatPenyewa,
  }) async {
    emit(RenterIndexLoading());

    try {
      final params = {
        "nama_penyewa": namaPenyewa,
        "no_telp": noTelp,
        "alamat": alamatPenyewa,
      };

      final result = await renterRepository.createRenter(params);
      if (result.message.isNotEmpty) {
        getRenterList();
      } else {
        emit(AddRenterError(message: "Gagal menambahkan penyewaan"));
      }

    } on DioError catch (dioError) {
      debugPrint('DioError: ${dioError.message}');
      emit(AddRenterError(message: "Masalah koneksi ke server"));
    } catch (e) {
      debugPrint('Unexpected error: $e');
      emit(AddRenterError(message: "Terjadi kesalahan: ${e.toString()}"));
    }
  }

  void editRenter({
    required int id,
    required String namaPenyewa,
    required String noTelp,
    required String alamatPenyewa,
  }) async {
    emit(RenterIndexLoading());

    try {
      final params = {
        "nama_penyewa": namaPenyewa,
        "no_telp": noTelp,
        "alamat": alamatPenyewa,
      };

      final result = await renterRepository.updateRenter(id,params);
      if (result.message.isNotEmpty) {
        getRenterList();
      } else {
        emit(AddRenterError(message: "Gagal menambahkan penyewaan"));
      }

    } on DioError catch (dioError) {
      debugPrint('DioError: ${dioError.message}');
      emit(AddRenterError(message: "Masalah koneksi ke server"));
    } catch (e) {
      debugPrint('Unexpected error: $e');
      emit(AddRenterError(message: "Terjadi kesalahan: ${e.toString()}"));
    }
  }

}
