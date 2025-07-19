import 'package:flutter_pos/data/model/forklift_data.dart';

class getForklistResponse {
  final List<Forklift> forklift;

  getForklistResponse({required this.forklift});

  factory getForklistResponse.fromJson(List<dynamic> json) {
    List<Forklift> forklifts = [];
    for (int i = 0; i < json.length; i++) {
      Forklift type = Forklift.fromJson(json[i]);
      forklifts.add(type);
    }
    return getForklistResponse(forklift: forklifts);
  }
}
