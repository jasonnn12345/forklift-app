class EditRenterResponse {
  final String message;

  EditRenterResponse({required this.message});

  factory EditRenterResponse.fromJson(Map<String, dynamic> json) {
    return EditRenterResponse(
    message: json['message'] ?? '', 
    );
  }
}
