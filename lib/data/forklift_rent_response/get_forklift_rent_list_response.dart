import 'package:flutter_pos/data/model/forklift_data.dart';
import 'package:flutter_pos/data/model/forklift_rent_data.dart';

class getForklistRentResponse {
  final List<ForkliftRentData> forkliftRent;

  getForklistRentResponse({required this.forkliftRent});

  factory getForklistRentResponse.fromJson(List<dynamic> json) {
    List<ForkliftRentData> forkliftRents = [];
    for (int i = 0; i < json.length; i++) {
      ForkliftRentData type = ForkliftRentData.fromJson(json[i]);
      forkliftRents.add(type);
    }
    return getForklistRentResponse(forkliftRent: forkliftRents);
  }
}
