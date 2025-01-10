class StatusUser {
  final int id;
  final String status;
  final String statusEng;


  StatusUser({
    required this.id,
    required this.status,
    required this.statusEng,
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็น FormType
  factory StatusUser.fromJson(Map<String, dynamic> json) {
    return StatusUser(
      id: json['id'],
      status: json['status'],
      statusEng: json['statusEng'],

    );
  }
}
