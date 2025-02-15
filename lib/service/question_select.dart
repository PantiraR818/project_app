import 'package:project_app/page/Question.dart';
import 'package:project_app/service/option.dart';
import 'package:project_app/service/question.dart';
import 'package:project_app/service/save_data.dart';

class QuestionSelect {
  final int? id; // Primary key (optional if auto-generated)
  final SaveData? saveData; // Relationship with SaveData
  final int? saveDataId; // Foreign key
  final QuestionInterface? question; // Relationship with Question
  final int? questionId; // Foreign key
  final Option? option; // Relationship with Option
  final int? optionId; // Foreign key

  QuestionSelect({
    this.id,
    this.saveData,
    this.saveDataId,
    this.question,
    this.questionId,
    this.option,
    this.optionId,
  });

  // Factory method for JSON deserialization
  factory QuestionSelect.fromJson(Map<String, dynamic> json) {
    return QuestionSelect(
      id: json['id'],
      saveData: json['save_data'] != null ? SaveData.fromJson(json['save_data']) : null,
      saveDataId: json['save_data_id'],
      question: json['question'] != null ? QuestionInterface.fromJson(json['question']) : null,
      questionId: json['question_id'],
      option: json['option'] != null ? Option.fromJson(json['option']) : null,
      optionId: json['option_id'],
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'save_data': saveData?.toJson(),
      'save_data_id': saveDataId,
      'question': question?.toJson(),
      'question_id': questionId,
      'option': option?.toJson(),
      'option_id': optionId,
    };
  }
}