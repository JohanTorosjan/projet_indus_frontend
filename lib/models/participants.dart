class Participants {
  int id;
  String name;
  bool isConfirmedAccount;
  int age;

  Participants(this.id, this.name, this.isConfirmedAccount, this.age);

  factory Participants.fromJson(Map<String, dynamic> json) {
    return Participants(
      json['id'],
      json['name'],
      json['isConfirmedAccount'],
      json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isConfirmedAccount': isConfirmedAccount,
      'age': age,
    };
  }
}
