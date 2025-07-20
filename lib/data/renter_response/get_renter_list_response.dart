import 'package:flutter_pos/data/model/forklift_data.dart';

import '../model/renter_data.dart';

class GetRenterResponse {
  final List<RenterData> renter;

  GetRenterResponse({required this.renter});

  factory GetRenterResponse.fromJson(List<dynamic> json) {
    List<RenterData> forklifts = [];
    for (int i = 0; i < json.length; i++) {
      RenterData type = RenterData.fromJson(json[i]);
      forklifts.add(type);
    }
    return GetRenterResponse(renter: forklifts);
  }
}
