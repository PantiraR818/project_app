class Interpre {
  final String nameInterpre;
  final int minInterpre;
  final int maxInterpre;
  final String colorProgress;
  final int formtypeId;

  Interpre({
    required this.nameInterpre,
    required this.minInterpre,
    required this.maxInterpre,
    required this.colorProgress,
    required this.formtypeId,
  });

  // Factory constructor for creating an instance from JSON
  factory Interpre.fromJson(Map<String, dynamic> json) {
    return Interpre(
      nameInterpre: json['nameInterpre'],
      minInterpre: json['min_Interpre'],
      maxInterpre: json['max_Interpre'],
      colorProgress: json['color_Progress'],
      formtypeId: json['formtype_id'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'nameInterpre': nameInterpre,
      'min_Interpre': minInterpre,
      'max_Interpre': maxInterpre,
      'color_Progress': colorProgress,
      'formtype_id': formtypeId,
    };
  }
}
