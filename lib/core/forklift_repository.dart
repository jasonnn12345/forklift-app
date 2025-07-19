import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos/core/dio_client.dart';
import 'package:flutter_pos/data/forklift_response/create_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/delete_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/edit_forklift_response.dart';
import 'package:flutter_pos/data/forklift_response/get_forklift_list_response.dart';

class ForkliftRepository extends DioClient {
  Future<getForklistResponse> getAllForkliftList() async {
    var response = await dio.get("forklift");
    return getForklistResponse.fromJson(response.data);
  }

  Future<CreateForkliftResponse> create(Map<String, dynamic> params) async {
    var response = await dio.post("forklift/create", data: params);
    return CreateForkliftResponse.fromJson(response.data);
  }

  Future<EditForkliftResponse> updateForklift(int id, Map<String, dynamic> data) async {
    final response = await dio.put('forklift/update/$id', data: data);
    return EditForkliftResponse.fromJson(response.data);
  }

  Future<DeleteForkliftResponse> deleteForklift(int id) async {
    final response = await dio.delete('forklift/delete/$id');
    return DeleteForkliftResponse.fromJson(response.data);
  }

}
