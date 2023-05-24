import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projet_indus/DTOs/eventrequestdto.dart';
import 'package:projet_indus/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:projet_indus/models/participants.dart';

class EventDAO {
  static String API_URL = "https://sortir-ce-soir-back.cluster-ig4.igpolytech.fr";

  Future<Event?> searchEvent(EventRequestDTO eventRequestDTO) async {
    print(eventRequestDTO);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final String apiUrl = '$API_URL/events';
    print(apiUrl);

    try {
      final jsonBody = json.encode(eventRequestDTO.toJson());
      print('ok encode');
      print(jsonBody);
      final response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);

      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('ok decode');
        print(jsonData);
        Event event = Event.fromJson(jsonData);
        List<Participants> participants = [];
        if (event.is_a_new_event == false) {
          for (var participant in jsonData["participants"]) {
            participant.add(Participants.fromJson(participant));
          }
        }
        event.participants = participants;
        return event;
      }
    } catch (err) {
      print(err);
    }
  }

  Future<Event?> getEvent(int id) async {
    String apiUrl = "$API_URL/events/$id";
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonString = response.body;
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(jsonString.runes.toList()));
        print(jsonData);
        Event event = Event.fromJson(jsonData);
        List<Participants> participants = [];
        print(jsonData["participants"]);
        for (var participant in jsonData["participants"]) {
          participants.add(Participants.fromJson(participant));
        }

        event.participants = participants;
        return event;
      }
    } catch (err) {
      print(err);
    }
  }
}
