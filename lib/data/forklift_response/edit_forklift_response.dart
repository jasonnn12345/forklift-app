class EditForkliftResponse {
  final String message;

  EditForkliftResponse({required this.message});

  factory EditForkliftResponse.fromJson(Map<String, dynamic> json) {
    return EditForkliftResponse(
    message: json['message'] ?? '', 
    );
  }
}
