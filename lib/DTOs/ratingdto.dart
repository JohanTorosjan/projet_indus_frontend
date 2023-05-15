class RatingDTO {
  final int id;
  final bool choice;

  RatingDTO({required this.id, required this.choice});
  Map<String, dynamic> toJson() {
    return {
      'idQuestion': id,
      'choice': choice,
    };
  }
}
