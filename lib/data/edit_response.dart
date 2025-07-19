class EditResponse {
  final String message;

  EditResponse({required this.message});

  factory EditResponse.fromJson(Map<String, dynamic> json) {
    return EditResponse(
    message: json['message'] ?? '', 
    );
  }
}
