class Option {
  final int id;
  final String optionName;
  final int score;
  final int formtypeId;

  // Constructor
  Option({
    required this.id,
    required this.optionName,
    required this.score,
    required this.formtypeId,
  });

  // Factory method to create an Option object from JSON
  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      optionName: json['option_name'],
      score: json['score'],
      formtypeId: json['formtype_id'],
    );
  }

  // Method to convert Option object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'option_name': optionName,
      'score': score,
      'formtype_id': formtypeId,
    };
  }
}