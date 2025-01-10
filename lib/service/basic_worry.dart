class BasicWorry {
  final int id;
  final String nameWorry;
  final String nameWorryEng;

  // Constructor
  BasicWorry({
    required this.id,
    required this.nameWorry,
    required this.nameWorryEng,
  });

  // จาก JSON -> Object
  factory BasicWorry.fromJson(Map<String, dynamic> json) {
    return BasicWorry(
      id: json['id'],
      nameWorry: json['nameWorry'],
      nameWorryEng: json['nameWorryEng'],
    );
  }

  // จาก Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameWorry': nameWorry,
      'nameWorryEng': nameWorryEng,
    };
  }
}
