import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos/core/dio_client.dart';
import 'package:flutter_pos/data/forklift_rent_response/get_forklift_rent_list_response.dart';
import 'package:flutter_pos/data/forklift_response/create_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/delete_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/edit_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/get_forklift_list_response.dart';
import 'package:flutter_pos/data/renter_response/create_renter_response.dart';
import 'package:flutter_pos/data/renter_response/delete_renter_response.dart';
import 'package:flutter_pos/data/renter_response/edit_renter_response.dart';
import 'package:flutter_pos/data/renter_response/get_renter_list_response.dart';

class RenterRepository extends DioClient {
  Future<GetRenterResponse> getAllRenterList() async {
    var response = await dio.get("penyewa/list");
    return GetRenterResponse.fromJson(response.data);
  }

  Future<CreateRenterResponse> createRenter(Map<String, dynamic> params) async {
    var response = await dio.post("penyewa/create", data: params);
    return CreateRenterResponse.fromJson(response.data);
  }

  Future<EditRenterResponse> updateRenter(int id, Map<String, dynamic> data) async {
    final response = await dio.put('penyewa/update/$id', data: data);
    return EditRenterResponse.fromJson(response.data);
  }

  Future<DeleteRenterResponse> deleteRenter(int id) async {
    final response = await dio.delete('penyewa/delete/$id');
    return DeleteRenterResponse.fromJson(response.data);
  }
}
