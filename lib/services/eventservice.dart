import 'package:projet_indus/DAOs/eventdao.dart';
import 'package:projet_indus/DTOs/eventrequestdto.dart';

import '../models/event.dart';

class EventService {
  EventDAO eventDAO = EventDAO();
  Future<Event?> searchEvent(EventRequestDTO eventRequestDTO) async {
    Event? event = await eventDAO.searchEvent(eventRequestDTO);
    print("DAO FINISHED: ");
    print(event);

    if (event == null) {
      return null;
    } else {
      return event;
    }
  }

  Future<Event?> getEvent(int? id) async {
    Event? event = await eventDAO.getEvent(id!);
    print("DAO FINISHED: ");
    print(event);
    if (event == null) {
      return null;
    } else {
      return event;
    }
  }
}
