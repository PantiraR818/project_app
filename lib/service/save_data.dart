import 'package:project_app/service/acc_user.dart';
import 'package:project_app/service/conern_fac_map.dart';
import 'package:project_app/service/form_type.dart';
import 'package:project_app/service/question_select.dart';
import 'package:project_app/service/status_user.dart';

class SaveData {
  final int? id; // Primary key (optional if auto-generated)
  final FormType? formType; // Relationship with FormType
  final int? formTypeId; // Foreign key
  final AccUser? accUser; // Relationship with AccUser
  final int? accId; // Foreign key
  final String interpreLevel; // Required field
  final int? statusId; // Foreign key
  final int? score; // Optional field
  final StatusUser? status; // Relationship with StatusUser
  final List<QuestionSelect>? questionSelect; // HasMany relationship
  final List<ConcernFacMap>? concernMatch; // HasMany relationship

  SaveData({
    this.id,
    this.formType,
    this.formTypeId,
    this.accUser,
    this.accId,
    required this.interpreLevel,
    this.statusId,
    this.score,
    this.status,
    this.questionSelect,
    this.concernMatch,
  });

  // Factory method for JSON deserialization
  factory SaveData.fromJson(Map<String, dynamic> json) {
    return SaveData(
      id: json['id'],
      formType: json['formType'] != null ? FormType.fromJson(json['formType']) : null,
      formTypeId: json['formtype_id'],
      accUser: json['accUser'] != null ? AccUser.fromJson(json['accUser']) : null,
      accId: json['acc_id'],
      interpreLevel: json['interpre_level'],
      statusId: json['status_id'],
      score: json['score'],
      status: json['status'] != null ? StatusUser.fromJson(json['status']) : null,
      questionSelect: json['question_select'] != null
          ? (json['question_select'] as List).map((e) => QuestionSelect.fromJson(e)).toList()
          : null,
      concernMatch: json['concern_match'] != null
          ? (json['concern_match'] as List).map((e) => ConcernFacMap.fromJson(e)).toList()
          : null,
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formType': formType?.toJson(),
      'formtype_id': formTypeId,
      'accUser': accUser?.toJson(),
      'acc_id': accId,
      'interpre_level': interpreLevel,
      'status_id': statusId,
      'score': score,
      'status': status?.toJson(),
      'question_select': questionSelect?.map((e) => e.toJson()).toList(),
      'concern_match': concernMatch?.map((e) => e.toJson()).toList(),
    };
  }
}
