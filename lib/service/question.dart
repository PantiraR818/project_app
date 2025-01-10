class QuestionInterface {
  final int id;
  final String question;
  final int question_type;

  QuestionInterface({
    required this.id,
    required this.question,
    required this.question_type,
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็น Question
  factory QuestionInterface.fromJson(Map<String, dynamic> json) {
    return QuestionInterface(
      id: json['id'] ?? 0, // กำหนดค่าเริ่มต้นเป็น 0 ถ้าเป็น null
      question: json['question'] ?? 'No question available', // กำหนดค่าเริ่มต้นเป็นข้อความนี้ถ้าเป็น null
      question_type: json['question_type'] ?? 0, // กำหนดค่าเริ่มต้นเป็น 0 ถ้าเป็น null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'question_type': question_type,
    };
  }
}
