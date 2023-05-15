class Question {
  final int id;
  final String label;
  final String choice0;
  final String choice1;

  Question({required this.id,required this.label, required this.choice0, required this.choice1});
   factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      label: json['label'] as String,
      choice0: json['choice0'] as String,
      choice1: json['choice1'] as String,
    );
  }
}
