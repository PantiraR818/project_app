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
  final FormType formType;
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
    required this.formType,
    required this.concernMatch,
  });

  // Factory method to create HistorySave from JSON
  factory HistorySave.fromJson(Map<String, dynamic> json) {
    var list = json['concern_match'] as List;
    List<ConcernFacMap> concernMatchList = list.map((i) => ConcernFacMap.fromJson(i)).toList();

    return HistorySave(
      id: json['id'],
      formtypeId: json['formtype_id'],
      accId: json['acc_id'],
      interpreLevel: json['interpre_level'],
      statusId: json['status_id'],
      score: json['score'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      formType: FormType.fromJson(json['formType']),
      concernMatch: concernMatchList, 
      interpre_color: json['interpre_color'],
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
      'formType': formType.toJson(),
      'concern_match': concernMatch.map((e) => e.toJson()).toList(),
    };
  }
}


class FormType {
  final int id;
  final String nameType;
  final String nameTypeEng;
  final int maxScore;
  final int minScore;
  final int type;
  final DateTime createdAt;
  final DateTime updatedAt;

  FormType({
    required this.id,
    required this.nameType,
    required this.nameTypeEng,
    required this.maxScore,
    required this.minScore,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method for creating FormType from JSON
  factory FormType.fromJson(Map<String, dynamic> json) {
    return FormType(
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

  // Method for converting FormType to JSON
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

