class CreateForkliftResponse {
  final String message;

  CreateForkliftResponse({required this.message});

  factory CreateForkliftResponse.fromJson(Map<String, dynamic> json) {
    return CreateForkliftResponse(message: json['message']);
  }
}
