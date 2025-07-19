class DeleteResponse {
  final String message;

  DeleteResponse({required this.message});

  factory DeleteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteResponse(
      message: json['message'] ?? '',
    );
  }
}
