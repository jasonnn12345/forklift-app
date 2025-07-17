import 'package:flutter_pos/data/model/item_type.dart';

class IndexResponse {
  final List<ItemType> itemTypes;

  IndexResponse({required this.itemTypes});

  factory IndexResponse.fromJson(List<dynamic> json) {
    List<ItemType> itemTypes = [];
    for (int i = 0; i < json.length; i++) {
      ItemType type = ItemType.fromJson(json[i]);
      itemTypes.add(type);
    }
    return IndexResponse(itemTypes: itemTypes);
  }
}
