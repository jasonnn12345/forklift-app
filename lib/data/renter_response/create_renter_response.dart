class CreateRenterResponse {
  final String message;

  CreateRenterResponse({required this.message});

  factory CreateRenterResponse.fromJson(Map<String, dynamic> json) {
    return CreateRenterResponse(message: json['message']);
  }
}
