class EventData{
  final String eventName;
  final String adminEmail;

  const EventData({
    required this.eventName,
    required this.adminEmail
  });

  static EventData fromJson(json) => EventData(eventName: json['name'], adminEmail: json['admin']);
}