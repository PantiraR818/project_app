import 'package:project_app/service/conern_fac_map.dart';

class HistorySave {
  final int id;
  final int formtypeId;
  final int accId;
  final String interpreLevel;
  final String interpre_color;
  final int statusId;
  final int score;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FormTypeRelation formTypeRelation;
  final List<ConcernFacMap> concernMatch;

  HistorySave({
    required this.id,
    required this.formtypeId,
    required this.accId,
    required this.interpreLevel,
    required this.interpre_color,
    required this.statusId,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.formTypeRelation,
    required this.concernMatch,
  });

  // Factory method to create HistorySave from JSON
  factory HistorySave.fromJson(Map<String, dynamic> json) {
  var list = json['Conern_Fac_Map'] as List?; // Fix the key name
  List<ConcernFacMap> concernMatchList =
      list?.map((i) => ConcernFacMap.fromJson(i)).toList() ?? [];

  return HistorySave(
    id: json['id'],
    formtypeId: json['formtype_id'],
    accId: json['acc_id'],
    interpreLevel: json['interpre_level'],
    interpre_color: json['interpre_color'], // Add this field
    statusId: json['status_id'],
    score: json['score'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    formTypeRelation: FormTypeRelation.fromJson(json['formTypeRelation']),
    concernMatch: concernMatchList,
  );
}


  // Convert HistorySave to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formtype_id': formtypeId,
      'acc_id': accId,
      'interpre_level': interpreLevel,
      'status_id': statusId,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'formType': formTypeRelation.toJson(),
      'concern_match': concernMatch.map((e) => e.toJson()).toList(),
    };
  }
}


class FormTypeRelation {
  final int id;
  final String nameType;
  final String nameTypeEng;
  final int maxScore;
  final int minScore;
  final int type;
  final DateTime createdAt;
  final DateTime updatedAt;

  FormTypeRelation({
    required this.id,
    required this.nameType,
    required this.nameTypeEng,
    required this.maxScore,
    required this.minScore,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method for creating formTypeRelation from JSON
  factory FormTypeRelation.fromJson(Map<String, dynamic> json) {
    return FormTypeRelation(
      id: json['id'],
      nameType: json['nameType'],
      nameTypeEng: json['nameTypeEng'],
      maxScore: json['max_score'],
      minScore: json['min_score'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method for converting formTypeRelation to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameType': nameType,
      'nameTypeEng': nameTypeEng,
      'max_score': maxScore,
      'min_score': minScore,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

