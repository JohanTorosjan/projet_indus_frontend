import 'package:projet_indus/services/friendsService.dart';

class Friends {
  final int id;
  final String name;
  final String instagram;
  final DateTime dob;
  bool selected;

  Friends(
      {required this.id,
      required this.name,
      required this.instagram,
      required this.dob,
      this.selected = false});

  factory Friends.fromJson(Map<String, dynamic> json) {
    return Friends(
      id: json['id'],
      name: json['name'],
      instagram: json['instagram'],
      dob: DateTime.parse(json['dob']),
    );
  }
}
