import 'package:project_app/service/match_worry_fac.dart';

class Faculties {
  final int? id; // Primary key (ถ้ามี)
  final String faculties; // ชื่อคณะ (ต้องกรอก)
  final String? phone; // เบอร์โทรศัพท์ (อาจจะเว้นว่างได้)
  final List<MatchWorryFac>? matchWorryFac; // ความสัมพันธ์กับ MatchWorryFac

  Faculties({
    this.id,
    required this.faculties,
    this.phone,
    this.matchWorryFac,
  });

  // Factory method สำหรับ JSON deserialization
  factory Faculties.fromJson(Map<String, dynamic> json) {
    return Faculties(
      id: json['id'], // Primary key ถ้ามีใน JSON
      faculties: json['faculties'], // ชื่อคณะ
      phone: json['phone'], // เบอร์โทรศัพท์
      matchWorryFac: json['matchWorryFac'] != null
          ? (json['matchWorryFac'] as List)
              .map((e) => MatchWorryFac.fromJson(e))
              .toList()
          : null, // ถ้ามีรายการ matchWorryFac
    );
  }

  // Method สำหรับ JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'faculties': faculties,
      'phone': phone,
      'matchWorryFac': matchWorryFac?.map((e) => e.toJson()).toList(),
    };
  }
}