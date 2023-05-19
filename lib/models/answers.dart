class Answers {
   String label;
  final int id;
  bool isSelected;
  Answers({required this.label, required this.id,this.isSelected =false});

  factory Answers.fromJson(Map<String, dynamic> json) {
    return Answers(
      label: json['label'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'id': id,
    };
  }
}
