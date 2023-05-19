import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class Client {
  final int? id;
  final String? firebase_id;
  final String? email;
  final String? name;
  final String? instagram;
  final DateTime? dob;
  bool? has_active_session;
  final int? answered_questions;

  Client(
      {this.id,
      this.firebase_id,
      this.dob,
      this.email,
      this.has_active_session,
      this.instagram,
      this.name,
      this.answered_questions});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        firebase_id: json["firebase_id"],
        dob: DateTime.parse(json["dob"]),
        email: json["email"],
        has_active_session: json["has_active_session"],
        instagram: json["instagram"],
        name: json["name"],
        answered_questions: json["answered_questions"],
      );

  Map<String, dynamic> toJson() => {
        "firebase_id": firebase_id,
        "dob": dob.toString(),
        "email": email,
        "has_active_session": has_active_session,
        "instagram": instagram,
        "name": name,
        "answered_questions": answered_questions,
      };
}
