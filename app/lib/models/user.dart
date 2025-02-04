class ModelUser {
  final String? name;
  final String? number;
  final String? email;

  ModelUser({required this.name, required this.number, required this.email});

 factory ModelUser.fromJson(Map<String, dynamic> json) {
  return ModelUser(
    name: json["name"] ?? "", 
    number: json["number"] ?? "",
    email: json["email"] ?? "",
  );
}
Map<String, dynamic> toJson() {
    return {
      "name": name,
      "number": number,
      "email": email,
    };
  }
}
