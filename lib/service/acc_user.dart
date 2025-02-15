import 'package:project_app/service/save_data.dart';

enum Gender {
  MALE, // ชาย
  FEMALE, // หญิง
  LGBTQ_PLUS, // LGBTQIAN+
}

class AccUser {
  final int? id; // Primary key (optional if auto-generated)
  final String email; // Required field
  final String? name; // Optional field
  final String? idStudent; // Corresponds to `id_student`, optional
  final DateTime? birthday; // Corresponds to `birthday`, optional
  final Gender? gender; // Gender enum, optional
  final String? faculty; // Optional field
  final String? phone; // Optional field

  // Relationships
  final List<SaveData>? saveData; // Represents the related SaveData records

  AccUser({
    this.id,
    required this.email,
    this.name,
    this.idStudent,
    this.birthday,
    this.gender,
    this.faculty,
    this.phone,
    this.saveData,
  });

  // Factory method for JSON deserialization
  factory AccUser.fromJson(Map<String, dynamic> json) {
    return AccUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      idStudent: json['id_student'], // ใช้ชื่อที่ตรงกับ JSON
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      gender: json['gender'] != null
          ? ({
              "ชาย": Gender.MALE,
              "หญิง": Gender.FEMALE,
              "LGBTQIAN+": Gender.LGBTQ_PLUS,
            }[json['gender']] ?? null)
          : null,
      faculty: json['faculty'],
      phone: json['phone'],
      saveData: json['saveData'] != null
          ? (json['saveData'] as List).map((e) => SaveData.fromJson(e)).toList()
          : null,
    );
  }

  toJson() {}

}
