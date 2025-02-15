import 'package:project_app/service/match_worry_fac.dart';
import 'package:project_app/service/save_data.dart';

class ConcernFacMap {
  final int? id; // Primary key (optional if auto-generated)
  final int? matchId; // Foreign key for match_worry_fac
  final MatchWorryFac? matchWorryFac; // Relationship with MatchWorryFac
  final int? saveDataId; // Foreign key for SaveData
  final SaveData? saveData; // Relationship with SaveData

  ConcernFacMap({
    this.id,
    this.matchId,
    this.matchWorryFac,
    this.saveDataId,
    this.saveData,
  });

  // Factory method for JSON deserialization
  factory ConcernFacMap.fromJson(Map<String, dynamic> json) {
    return ConcernFacMap(
      id: json['id'],
      matchId: json['match_id'],
      matchWorryFac: json['match_worry_fac'] != null
          ? MatchWorryFac.fromJson(json['match_worry_fac'])
          : null,
      saveDataId: json['save_data_id'],
      saveData: json['save_data'] != null ? SaveData.fromJson(json['save_data']) : null,
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_id': matchId,
      'match_worry_fac': matchWorryFac?.toJson(),
      'save_data_id': saveDataId,
      'save_data': saveData?.toJson(),
    };
  }
}
