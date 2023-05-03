class EventData{
  final String name;
  final String e_id;
  final String date;
  final String end;
  final String start;
  final String g_id;
  final String description;
  final String user;
  final String u_id;

  const EventData({
    required this.name,
    required this.e_id,
    required this.date,
    required this.end,
    required this.start,
    required this.g_id,
    required this.description,
    required this.user,
    required this.u_id,
  });

  static EventData fromJson(json) => EventData(name: json['name'].toString(),e_id: json['e_id'].toString(),date:json['date'].toString() ,end:json['end'].toString() ,start: json['start'].toString(),g_id: json['g_id'].toString(),description: json['description'].toString(),user: json['user'].toString(),u_id: json['u_id'].toString());
}

