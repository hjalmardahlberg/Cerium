class EventData{
  final String eventName;


  const EventData({
    required this.eventName,
  });

  static EventData fromJson(json) => EventData(eventName: json['name']);
}

