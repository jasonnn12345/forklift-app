class ItemType {
  final int id;
  final String code;
  final String name;
  final String status;

  ItemType({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      status: json["status"],
    );
  }
}
