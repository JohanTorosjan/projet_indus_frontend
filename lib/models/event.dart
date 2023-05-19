import 'package:intl/intl.dart';
import 'package:projet_indus/models/participants.dart';

import 'infrastructure.dart';

class Event {
  Infrastructure infrastructure;
  List<Participants> participants;
  DateTime starting_hour;
  double percentage_of_matching;
  bool is_a_new_event;

  Event(this.infrastructure, this.participants, this.starting_hour,
      this.percentage_of_matching, this.is_a_new_event);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      Infrastructure.fromJson(json['infrastructure']),
      [],
      // List<Participants>.from(
      //     json['participants'].map((x) => Participants.fromJson(x))),
      DateTime.parse(json['starting_hour']),
      json['percentage_of_matching'].toDouble(),
      json['is_a_new_event'],
    );
  }

  Map<String, dynamic> toJson() {
    final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');

    return {
      'infrastructure': infrastructure.toJson(),
      'participants': participants.map((x) => x.toJson()).toList(),
      'starting_hour': formatter.format(starting_hour),
      'percentage_of_matching': percentage_of_matching,
      'is_a_new_event': is_a_new_event,
    };
  }
}
