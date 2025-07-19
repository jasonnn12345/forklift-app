import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/data/model/item_type.dart';

class IndexResponse {
  final List<Forklift> forklift;

  IndexResponse({required this.forklift});

  factory IndexResponse.fromJson(List<dynamic> json) {
    List<Forklift> forklifts = [];
    for (int i = 0; i < json.length; i++) {
      Forklift type = Forklift.fromJson(json[i]);
      forklifts.add(type);
    }
    return IndexResponse(forklift: forklifts);
  }
}
