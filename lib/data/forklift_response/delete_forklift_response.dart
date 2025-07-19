class DeleteForkliftResponse {
  final String message;

  DeleteForkliftResponse({required this.message});

  factory DeleteForkliftResponse.fromJson(Map<String, dynamic> json) {
    return DeleteForkliftResponse(
      message: json['message'] ?? '',
    );
  }
}
