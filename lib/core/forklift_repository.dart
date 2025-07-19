import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos/core/dio_client.dart';
import 'package:flutter_pos/data/create_response.dart';
import 'package:flutter_pos/data/delete_response.dart';
import 'package:flutter_pos/data/edit_response.dart';
import 'package:flutter_pos/data/index_response.dart';

class ForkliftRepository extends DioClient {
  Future<CreateResponse> create(Map<String, dynamic> params) async {
    var response = await dio.post("forklift/create", data: params);
    return CreateResponse.fromJson(response.data);
  }

  Future<IndexResponse> index() async {
    debugPrint("==== MULAI GET FORKLIFT ====");

    var response = await dio.get("forklift");
    debugPrint("GET RESPONSE: ${response.data}");
    return IndexResponse.fromJson(response.data);

  }
  Future<EditResponse> update(int id, Map<String, dynamic> data) async {
    final response = await dio.put('forklift/update/$id', data: data);
    return EditResponse(message: response.data['message']);
  }
  Future<DeleteResponse> delete(int id) async {
    final response = await dio.delete('forklift/delete/$id');
    return DeleteResponse.fromJson(response.data);
  }

}
