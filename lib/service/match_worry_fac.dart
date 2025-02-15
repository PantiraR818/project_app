import 'package:project_app/service/basic_worry.dart';
import 'package:project_app/service/conern_fac_map.dart';
import 'package:project_app/service/faculties.dart';

class MatchWorryFac {
  final int? id; // Primary key (ถ้ามี)
  final BasicWorry? basicWorry; // ความสัมพันธ์กับ BasicWorry
  final int basicWorryId; // Foreign key ไปยัง BasicWorry
  final Faculties? faculties; // ความสัมพันธ์กับ Faculties
  final int facultiesId; // Foreign key ไปยัง Faculties
  final List<ConcernFacMap>? concern_match; // ความสัมพันธ์กับ ConcernFacMap

  MatchWorryFac({
    this.id,
    this.basicWorry,
    required this.basicWorryId,
    this.faculties,
    required this.facultiesId,
    this.concern_match,
  });

  // Factory method สำหรับ JSON deserialization
  factory MatchWorryFac.fromJson(Map<String, dynamic> json) {
    return MatchWorryFac(
      id: json['id'], // Primary key ถ้ามีใน JSON
      basicWorry: json['basicWorry'] != null
          ? BasicWorry.fromJson(json['basicWorry'])
          : null, // ถ้า basicWorry มีข้อมูล
      basicWorryId: json['basic_worry_id'], // Foreign key
      faculties: json['faculties'] != null
          ? Faculties.fromJson(json['faculties'])
          : null, // ถ้า faculties มีข้อมูล
      facultiesId: json['faculties_id'], // Foreign key
      concern_match: json['concernMatch'] != null
          ? (json['concernMatch'] as List)
              .map((e) => ConcernFacMap.fromJson(e))
              .toList()
          : null, // ถ้า concernMatch มีข้อมูล
    );
  }

  // Method สำหรับ JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'basicWorry': basicWorry?.toJson(),
      'basic_worry_id': basicWorryId,
      'faculties': faculties?.toJson(),
      'faculties_id': facultiesId,
      'concern_match': concern_match?.map((e) => e.toJson()).toList(),
    };
  }
}