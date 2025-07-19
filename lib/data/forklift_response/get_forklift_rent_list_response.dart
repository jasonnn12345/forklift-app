import 'package:flutter_pos/data/model/forklift_data.dart';

class getForklistResponse {
  final List<ForkliftData> forklift;

  getForklistResponse({required this.forklift});

  factory getForklistResponse.fromJson(List<dynamic> json) {
    List<ForkliftData> forklifts = [];
    for (int i = 0; i < json.length; i++) {
      ForkliftData type = ForkliftData.fromJson(json[i]);
      forklifts.add(type);
    }
    return getForklistResponse(forklift: forklifts);
  }
}
