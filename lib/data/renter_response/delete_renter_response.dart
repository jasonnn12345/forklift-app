class DeleteRenterResponse {
  final String message;

  DeleteRenterResponse({required this.message});

  factory DeleteRenterResponse.fromJson(Map<String, dynamic> json) {
    return DeleteRenterResponse(
      message: json['message'] ?? '',
    );
  }
}
