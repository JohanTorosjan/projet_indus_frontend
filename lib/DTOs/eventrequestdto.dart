class EventRequestDTO {
  List<int>? users_id;

  List<int?> usages_questions_ids;
  List<int?> usages_questions_answers_ids;

  EventRequestDTO(
      {this.users_id,
      required this.usages_questions_ids,
      
      required this.usages_questions_answers_ids});


      
      factory EventRequestDTO.fromJson(Map<String, dynamic> json) {
    return EventRequestDTO(
      users_id: json['users_id'] != null ? List<int>.from(json['users_id']) : null,
      usages_questions_ids: List<int>.from(json['usages_questions_ids']),
      usages_questions_answers_ids: List<int>.from(json['usages_questions_answers_ids']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'usages_questions_ids': usages_questions_ids,
      'usages_questions_answers_ids': usages_questions_answers_ids,
    };
    if (users_id != null) {
      data['users_id'] = users_id;
    }
    return data;
  }
}
