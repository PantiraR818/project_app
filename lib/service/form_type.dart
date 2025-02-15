class FormType {
  final int id;
  final String nameType;
  final String nameTypeEng;
  final int maxScore;
  final int minScore;
  final int type;

  FormType({
    required this.id,
    required this.nameType,
    required this.nameTypeEng,
    required this.maxScore,
    required this.minScore,
    required this.type,
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็น FormType
  factory FormType.fromJson(Map<String, dynamic> json) {
    return FormType(
      id: json['id'],
      nameType: json['nameType'],
      nameTypeEng: json['nameTypeEng'],
      maxScore: json['max_score'],
      minScore: json['min_score'],
      type: json['type'],
    );
  }

  toJson() {}
}
