import 'package:project_app/service/form_type.dart';

class Guidance {
  final String guidance;
  final int formtype_id;
  final FormType formType;

  // Constructor
  Guidance({
    required this.guidance,
    required this.formtype_id,
    required this.formType,
  });

 // จาก JSON -> Object
  factory Guidance.fromJson(Map<String, dynamic> json) {
    return Guidance(
      guidance: json['guidance'],
      formtype_id: json['formtype_id'],
      formType: json['formType'],
    );
  }

    // จาก Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'guidance': guidance,
      'formtype_id': formtype_id,
      'formType': formType,
    };
  }
}
  